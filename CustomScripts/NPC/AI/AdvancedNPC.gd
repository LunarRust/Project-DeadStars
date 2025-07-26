@icon("res://Sprites/iconsmile128Gold.png")
extends CharacterBody3D

@export_category("Assignments")
@export var nav_agent : NavigationAgent3D
@export var anim : AnimationPlayer
@export var animTree : AnimationTree
@export var modelRoot : Node3D
@export var HealthHandler : Node3D
@export var PompBehavior : Node
@export var DialogueSystem : Node3D
@export var SoundSource : AudioStreamPlayer3D
@export var InvManager : Node3D
@export var FlashLight : SpotLight3D
@export var DebugLabelParent : Node3D
var TargetEntity
var NavNodeTarget : Node
var AcknowledgeNVT : bool = false
var PreviousNavNodeTarget : Node
var PreviousTarget
var DoLookAt : bool = false
var LookTarget : Node3D

@export_category("Characteristics")
@export var hostile : bool = true
@export var RespectPlayerController : bool = true
@export var MaxSpeed: float = 3
var speed : float
@export var acceleration: float = 5
@export var MaxDistanceDef : float = 1.5
var MaxDistance : float
@export var NavUpdateInterval : float = 1

@export_category("Attack Data")
@export var attackThreshold : float = 1.5
@export var AttackDistance : float = 2
var AttackDistanceDefault : float
@export var attackPower : int = 1
@export var aggroRange : int = 10
var walkName = "Walk"
var attackName = "Attack"
var meleeAttack : bool = true

var SpawnerID : int
var AllowPlayerCon : bool = true
var attackTimer : float
var attacking : bool = false
var running : bool = false
var hurt : bool = false
var Tset : bool = false
var TargetIsItem : bool = false
var TargetIsUsable : bool = false
var TargetIsCreature : bool = false
var TargetReached : bool = false
var velV2 : Vector2
var forwardVel : float
@export var NewVelocity : Vector3
@export var LastLocation : Vector3
var direction : Vector3
var PointNavrunning : bool
var InstID
var SignalBusKOM
var SignalBusInnout
var InnoutExists : bool = false
var instance
var player
var NewDialogueSystemActive : bool = false
var RandFloat : float
var PathFindClock : float
var ActionOnArrive : int = 0
@onready var playerHealthInstance = get_tree().get_first_node_in_group("PlayerHealthHandler")

var LightSound = preload("res://Sounds/FlashLight.ogg")

func _ready():
	RandFloat = randf_range(-0.2,0.2)
	PathFindClock = RandFloat
	instance = self
	InstID = self.get_instance_id()
	self.add_to_group(str(InstID))
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		SignalBusKOM = player.get_node("KOMSignalBus")
	if self.get_node("Behavior").NewDialogueSystem == true:
		NewDialogueSystemActive = true
	if get_tree().get_first_node_in_group("InnOutSignalBus") != null:
		SignalBusInnout = get_tree().get_first_node_in_group("InnOutSignalBus")
		InnoutExists = true
	else:
		InnoutExists = false
	player = get_tree().get_first_node_in_group("player")
	if SignalBusKOM != null && RespectPlayerController:
		SignalBusKOM.PompNpcInstances.append(InstID)
		SignalBusKOM.Activate_Pomp_Target.connect(TargetEnimies)
		SignalBusKOM.Activate_Player_Target.connect(TargetPlayer)
		SignalBusKOM.Light_Toggle.connect(FlashLightToggle)
		SignalBusKOM.Kill_pomp.connect(KillSelf)
		SignalBusKOM.Item_Grab.connect(LocateItem)
		SignalBusKOM.Light_On.connect(FlashLightOn)
		SignalBusKOM.Light_Off.connect(FlashLightOff)
		SignalBusKOM.NavToPoint.connect(NavToPoint)
		SignalBusKOM.ItemSpef.connect(NavToItem)
		SignalBusKOM.TargetCreature.connect(TargetCreature)
	MaxDistance = MaxDistanceDef
	AttackDistanceDefault = AttackDistance
	speed = MaxSpeed

	nav_agent.target_desired_distance = MaxDistance
	if (TargetEntity == null):
		print("Ouchie wawa! There's no defined player object for this enemy to chase! Trying to find one now.")
		if player != null:
			running = true
		else:
			running = false
	else:
		running = true
	CheckGlobals()
	DebugLabelParent.get_child(1).text = ("InstanceID " +  str(InstID))



func _physics_process(delta):
	if (running):
		if AllowPlayerCon:
			if Input.is_physical_key_pressed(KEY_5):
				TargetEntity = TargetLocator()
			if Tset:
				TargetEntity = TargetLocator()
			if Input.is_physical_key_pressed(KEY_6):
				hostile = false
				TargetEntity = TargetLocator("player")
			if Input.is_mouse_button_pressed(2) && RespectPlayerController:
				hostile = false
				DoLookAt = false
				TargetEntity = TargetLocator("NpcMarker",1.2)
				attacking = true
		running_handling(delta)


func running_handling(delta):
	if TargetIsCreature && TargetEntity != null:
		if !TargetEntity.is_in_group("player") && !TargetEntity.is_in_group("PompNPC"):
			hostile = true
		if (position.distance_to(TargetEntity.position) < aggroRange && !attacking && !hurt):
			attacking = true
		if (position.distance_to(TargetEntity.position) > MaxDistance && attacking && !hurt):
			handle_Move(delta)
		else:
			velocity = velocity.lerp(Vector3.ZERO, delta)
		if AcknowledgeNVT:
			if NavNodeTarget == null:
				NavNodeTarget = PreviousNavNodeTarget
			if position.distance_to(TargetEntity.position) < AttackDistance:
				ArrivalAction(ActionOnArrive)
				if NavNodeTarget != null:
					if NavNodeTarget.is_in_group("ExecOnReached"):
							if !TargetReached:
								NavNodeTarget.Reached(InstID)
			if attackTimer > attackThreshold:
				if NavNodeTarget != null:
					if NavNodeTarget.is_in_group("KillNPC"):
						if "InstID" in TargetEntity:
							if TargetEntity.InstID == InstID:
								attackTimer = 0
								var currentMark = get_tree().get_first_node_in_group("NavMark" + str(InstID))
								currentMark.queue_free()
								if NavNodeTarget.is_in_group("Respawn"):
									SignalBusKOM.emit_signal("CreateNpc",SpawnerID)
								KillSelf()
				else:
					print("NavNodeTarget is NULL")

		if (attackTimer > attackThreshold && attacking && hostile):
			Attack()
			attackTimer = 0
		if attackTimer > attackThreshold:
			attackTimer = 0
		if (position.distance_to(TargetEntity.position) < AttackDistance):
			attackTimer += 1 * delta
			TargetReached = true
		else:
			TargetReached = false


	elif TargetIsItem:
		if TargetEntity != null:
			if (position.distance_to(TargetEntity.position) > MaxDistance && !hurt):
				handle_Move(delta)
			else:
				velocity = velocity.lerp(Vector3.ZERO, delta)
			if (position.distance_to(TargetEntity.position) < AttackDistance):
				attackTimer += 1 * delta
			if (attackTimer > attackThreshold && position.distance_to(TargetEntity.position) < AttackDistance):
				GrabItem()
				attackTimer = 0

	elif TargetIsUsable:
		if TargetEntity != null:
			if (position.distance_to(TargetEntity.position) > MaxDistance && !hurt):
				handle_Move(delta)
			else:
				velocity = velocity.lerp(Vector3.ZERO, delta)
			if (position.distance_to(TargetEntity.position) < AttackDistance):
				attackTimer += 1 * delta
			if (attackTimer > attackThreshold && position.distance_to(TargetEntity.position) < AttackDistance):
				UseItem()
				attackTimer = 0
	else:
		TargetFallback()

	AnimAndVelocity(delta)

####MOVEMENT HANDLING##############
###Calculations based on speed, velocity and Distance to nav target
### Uses these values to determine animation blend positions
###################################
func AnimAndVelocity(delta):
	if TargetEntity != null:
		@warning_ignore("shadowed_variable")
		var forwardVel = abs(velocity.dot(transform.basis.z)) + abs(velocity.dot(transform.basis.x))
		if (position.distance_to(TargetEntity.position) < MaxDistance + 1.5):
			speed = (nav_agent.distance_to_target() - 1)
		else:
			speed = (nav_agent.distance_to_target()) + 0.286
		if speed >= MaxSpeed:
			speed = MaxSpeed
		if (nav_agent.distance_to_target() < MaxDistance + 3.5 && nav_agent.distance_to_target() > MaxDistance):
			if speed < 0.8:
				speed = 0.8
		velV2.y = lerp(velV2.y,forwardVel - 0.5,delta * 2)
		if velV2.y < 0:
			velV2.y = 0
		if self.position == LastLocation:
			velocity = Vector3(0,0,0)
		if DoLookAt && LookTarget != null:
			velV2.x = lerp(velV2.x,find_rotation_to(self,LookTarget),delta * 3)
		else:
			velV2.x = 0
		if (animTree != null):
			animTree["parameters/Normal2D/blend_position"] = velV2
			animTree["parameters/Normal2D/4/blend_position"] = float(HealthHandler.HP)
			animTree["parameters/TalkBlend/blend_position"] = velV2
			animTree["parameters/TouchBlend/blend_position"] = velV2
			if NewDialogueSystemActive:
				animTree["parameters/DialogueIdleBlend/blend_position"] = float(HealthHandler.HP)
				animTree["parameters/DialogueTalkBlend/blend_position"] = float(HealthHandler.HP)
				animTree["parameters/DialogueTalkBlend2/blend_position"] = float(HealthHandler.HP)

		if speed > 1.2:
			AttackDistance = 3
		else:
			AttackDistance = AttackDistanceDefault



func update_target_location(target_location):
	nav_agent.target_position = target_location

###################################
### Nav Targeting,Velocity, and modelroot rotation
###################################
func handle_Move(delta):
	PathFindClock += delta
	nav_agent.target_position = TargetEntity.global_position
	if PathFindClock > NavUpdateInterval:
		direction = nav_agent.get_next_path_position() - global_position
		PathFindClock = RandFloat

	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, delta * acceleration)
	NewVelocity = velocity
	nav_agent.set_velocity_forced(NewVelocity)
	#velocity = velocity.move_toward(direction * speed, .25)
	var lookTarget = Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z)
	var targetPos: Vector2 = Vector2(lookTarget.x, lookTarget.z)
	var modelPos : Vector2 = Vector2(modelRoot.global_position.x, modelRoot.global_position.z)
	if(!nav_agent.is_target_reachable() && velocity.length() / speed < .3):
		targetPos = Vector2(TargetEntity.global_position.x, TargetEntity.global_position.z)
	var modelDir = -(modelPos - targetPos)
	modelRoot.global_rotation.y = lerp_angle(modelRoot.global_rotation.y, atan2(modelDir.x, modelDir.y), delta * 4)
	move_and_slide()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	LastLocation = self.position
	velocity = velocity + clamp(safe_velocity,Vector3(-0.10,0,-0.10),Vector3(0.10,0,0.10))


###################################
###INTERACTION METHODS
###################################
func Attack():
	if (anim != null && TargetEntity.has_node("HealthController")):
		if !TargetEntity.get_node("HealthController").dead:
			animTrigger(attackName)
		else:
			pass
	if (position.distance_to(TargetEntity.position) < AttackDistance && TargetEntity.is_in_group("player")):
		animTrigger(attackName)
		playerHealthInstance.notsostatichealth(attackPower)
	else:
		if position.distance_to(TargetEntity.position) < AttackDistance && TargetEntity.has_node("HealthController"):
			if !TargetEntity.get_node("HealthController").dead:
				TargetEntity.get_node("HealthController").Hurt(1)
			else:
				TargetPlayer()
		elif position.distance_to(TargetEntity.position) < AttackDistance && TargetEntity.has_node("HealthHandler"):
			TargetEntity.get_node("HealthHandler").Hurt(1)
	await get_tree().create_timer(1.0).timeout

func GrabItem():
	if (anim != null):
		animTrigger("Touch")
	await get_tree().create_timer(1.0).timeout
	if TargetEntity != null:
		for i in get_all_children(TargetEntity):
			if (i.has_method("Touch")):
				i.Touch("AmNpc")
	hostile = false
	TargetIsItem = false
	TargetIsCreature = true
	TargetPlayer()
	LookTarget = player

func UseItem():
	if (anim != null):
		animTrigger("Touch")
	await get_tree().create_timer(1.0).timeout
	if TargetEntity != null:
		for i in get_all_children(TargetEntity):
			if (i.has_method("Item")):
				var ChallengeItem = create_item(i.itemMatch)
				var itemMatches : bool = false
				for items in self.get_node("InventoryGrid").get_items():
					if itemMatches == false:
						if items.prototype_id == ChallengeItem.prototype_id:
							if i.Item(items.prototype_id) == true:
								itemMatches = true
								self.get_node("InventoryGrid").remove_item(items)
	hostile = false
	TargetIsItem = false
	TargetIsCreature = true
	TargetPlayer()
	LookTarget = player

###################################
###CHECK AND PERFORM SELF-PARAMS
###################################
func FlashLightToggle():
	animTrigger("Flashlight");
	SoundSource.stream = LightSound
	SoundSource.play()
	if FlashLight.visible:
		FlashLight.visible = false
	else:
		FlashLight.visible = true
	print_rich("Flashlight toggled: [color=red]" + str(FlashLight.visible) + "[/color]")

func FlashLightOff():
	animTrigger("Flashlight");
	if SoundSource !=null:
		SoundSource.stream = LightSound
		SoundSource.play()
	FlashLight.visible = false
	print_rich("Flashlight toggled: [color=red]" + "OFF" + "[/color]")

func FlashLightOn():
	animTrigger("Flashlight");
	if SoundSource !=null:
		SoundSource.stream = LightSound
		SoundSource.play()
	FlashLight.visible = true
	print_rich("Flashlight toggled: [color=red]" + "ON" + "[/color]")

###################################
###
###################################
func CheckGlobals():
	if get_tree().get_first_node_in_group("NpcSceneRules") != null:
		var NpcRules = get_tree().get_first_node_in_group("NpcSceneRules")
		await  NpcRules.is_node_ready()
		if !NpcRules.FlashLightsEnabled:
			if FlashLight.visible:
				FlashLightOff()
		if !NpcRules.InventoryVisible:
			self.get_node("VenusModel/OrderPanel").hide()
		if NpcRules.AllowPlayerControl == true:
			AllowPlayerCon = true
		else:
			AllowPlayerCon = false


###################################
### Function from hell.
###################################
func NavToPoint(id : int,doLook : bool,NavNodeTargetFromSignalBus : Node,distance : float,Action : int,LookTargetFromBus : String):
	if id == InstID || id == 000:
		AcknowledgeNVT = true
		TargetEntity = TargetLocator("NavMark" + str(InstID),distance)
		if NavNodeTargetFromSignalBus != null:
			PreviousNavNodeTarget = NavNodeTarget
			NavNodeTarget = NavNodeTargetFromSignalBus
		ActionOnArrive = Action
		if doLook == true:
			if LookTargetFromBus == "default":
				LookTarget = NavNodeTargetFromSignalBus
			else:
				LookTarget = find_closest_or_furthest(self,LookTargetFromBus)
			DoLookAt = true
		else:
			DoLookAt = false

###################################
### This makes me sad, Surley there is a way around having a function with 6 required arguments.
###################################
func TargetCreature(id : int,doLook : bool,TargetEntityFromSignalBus : String,distance : float,LookTargetFromBus : String, isHostile : bool):
	TargetEntity = TargetLocator(TargetEntityFromSignalBus)
	AcknowledgeNVT = false
	hostile = isHostile
	MaxSpeed = 3
	if doLook == true:
		if LookTargetFromBus == "default":
			LookTarget = TargetEntity
		else:
			LookTarget = find_closest_or_furthest(self,LookTargetFromBus)
		DoLookAt = true
	else:
		DoLookAt = false
	TargetIsCreature = true
	TargetIsItem = false

###################################
###
###################################
func NavToItem(id : int,NavNodeTargetFromSignalBus : Node,Action : int):
	if id == InstID || id == 000:
		AcknowledgeNVT = false
		PreviousNavNodeTarget = NavNodeTarget
		PreviousTarget = TargetEntity
		NavNodeTarget = NavNodeTargetFromSignalBus
		ActionOnArrive = Action
		MaxDistance = 1
		TargetEntity = ItemLocator()

###################################
###
###################################
func ArrivalAction(action : int):
	match action:
		1:
			PompBehavior.Talk(false)
			ActionOnArrive = 0
		2:
			PompBehavior.Touch()
			ActionOnArrive = 0
		3:
			PompBehavior.Look()
			ActionOnArrive = 0
		4:
			HealthHandler.Hurt(1)
			ActionOnArrive = 0
		0:
			pass
		_:
			pass

###################################
###
###################################
func Speak(anim : int,SoundString : String):
	match anim:
		1:
			animTrigger("Talk")
		2:
			animTrigger("touch")
		3:
			animTrigger("Look")
		4:
			animTrigger("Hurt")
		0:
			pass
		_:
			pass
	DialogueSystem.soundSource.stream = load(SoundString) as AudioStream
	DialogueSystem.soundSource.play()

###################################
###
###################################
func TargetLocator(SpefTarget = "default",MaxDist = MaxDistanceDef):
	var NearestTarget
	if MaxDist != MaxDistanceDef:
		MaxDistance = MaxDist
	else:
		MaxDistance = MaxDistanceDef
	if SpefTarget != "default":
		NearestTarget = find_closest_or_furthest(self,SpefTarget)
		LookTarget = NearestTarget
		DoLookAt = true
	else:
		NearestTarget = find_closest_or_furthest(self)
		LookTarget = player
		DoLookAt = true
	Tset = false
	if NearestTarget != null:
		#print_rich("new target: [color=red]" + (NearestTarget.name) + "[/color]")
		TargetIsCreature = true
		TargetIsItem = false
		PreviousTarget = TargetEntity
		return NearestTarget
	else:
		hostile = false
		NearestTarget = self
		print_rich("new target: [color=red] NULL" + "[/color]")
		DoLookAt = false
		animTrigger("Shrug")
		PreviousTarget = TargetEntity
		return NearestTarget

###################################
###
###################################
func TargetFallback():
	hostile = false
	print_rich("[color=red]" + str(self.name) + "[/color]: TargetEntity no longer present in tree. Changing target to player.")
	if PreviousTarget != null:
		TargetEntity = PreviousTarget
	else:
		TargetPlayer()
	LookTarget = TargetEntity
	DoLookAt = true
	hostile = false
	TargetIsItem = false
	TargetIsCreature = true

###################################
###
###################################
func ItemLocator():
	var NearestTarget
	DoLookAt = true
	NearestTarget = find_closest_or_furthest(self,"default",true)
	if NearestTarget != null:
		print_rich("new target: [color=red]" + (NearestTarget.name) + "[/color]")
		TargetIsCreature = false
		TargetIsItem = true
		for i in get_all_children(NearestTarget):
			if self.get_node("InventoryGrid").can_add_item(create_item(i.get_node("Behavior").ItemID)):
				LookTarget = NearestTarget
				return NearestTarget
			else:
				print("Inventory is full!")
				animTrigger("Shrug")
				DoLookAt = false
				NearestTarget = null
				TargetIsItem = false
				TargetIsCreature = false
				PreviousTarget = TargetEntity
				return NearestTarget
	else:
		print("Item is Null!")
		animTrigger("Shrug")
		hostile = false
		TargetIsItem = false
		TargetIsCreature = false
		DoLookAt = false
		NearestTarget = null
		PreviousTarget = TargetEntity
		return NearestTarget

func UsableLocator():
	var NearestTarget
	DoLookAt = true
	NearestTarget = find_closest_or_furthest(self,"default",false,true,true)
	if NearestTarget != null:
		print_rich("new target: [color=red]" + (NearestTarget.name) + "[/color]")
		TargetIsCreature = false
		TargetIsItem = false
		TargetIsUsable = true
		for i in get_all_children(NearestTarget):
			if i.name == "Behavior":
				var ChallengeItem = create_item(i.itemMatch)
				var itemMatches : bool = false
				print("looking for: " + str(i.itemMatch))
				for items in self.get_node("InventoryGrid").get_items():
					print("casting with " + str(items.prototype_id))
					if items.prototype_id == ChallengeItem.prototype_id:
				#if self.get_node("InventoryGrid").has_item(ChallengeItem):
						itemMatches = true
						LookTarget = NearestTarget
						return NearestTarget
				if itemMatches == false:
					print("We do not have that Item!")
					animTrigger("Shrug")
					DoLookAt = false
					NearestTarget = null
					TargetIsItem = false
					TargetIsCreature = false
					TargetIsUsable = false
					PreviousTarget = TargetEntity
					return NearestTarget
	else:
		print("Usable is Null!")
		animTrigger("Shrug")
		hostile = false
		TargetIsItem = false
		TargetIsCreature = false
		TargetIsUsable = false
		DoLookAt = false
		NearestTarget = null
		PreviousTarget = TargetEntity
		return NearestTarget

###################################
###
###################################
func LocateItem():
	hostile = false
	TargetIsItem = true
	TargetIsUsable = false
	TargetEntity = ItemLocator()

func LocateUsable():
	hostile = false
	TargetIsItem = false
	TargetIsUsable = true
	TargetEntity = UsableLocator()

###################################
###
###################################
func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = InvManager.inv.item_protoset
	item.prototype_id = prototype_id
	return item

###################################
###
###################################
func TargetEnimies():
	attacking = true
	Tset = true
	TargetEntity = TargetLocator()
	LookTarget = TargetEntity
	if TargetEntity == self:
		LookTarget = player
	DoLookAt = true

###################################
###
###################################
func KillSelf():
	SignalBusKOM.PompNpcInstances.erase(InstID)
	self.get_node("HealthController").Hurt(99999)

###################################
###
###################################
func TargetPlayer(MaxDist = MaxDistanceDef):
	hostile = false
	TargetIsCreature = true
	TargetIsItem = false
	DoLookAt = true
	LookTarget = self
	if MaxDist != MaxDistanceDef:
		MaxDistance = MaxDist
	else:
		MaxDistance = MaxDistanceDef
	TargetEntity = get_tree().get_first_node_in_group("player")
	LookTarget = TargetEntity
	print_rich("new target: [color=red]" + (TargetEntity.name) + "[/color]")


###################################
###Yikes. would like to compress this function down.
###################################
func find_closest_or_furthest(node: Object,group_name = "default",item = false, get_closest:= true,itemUsable : bool = false) -> Object:
	@warning_ignore("unassigned_variable")
	var PossibleTargets : Array
	if group_name == "default" && item == false && itemUsable == false:
		for i in get_all_children(get_tree().get_root()):
			if i.is_class("Node3D"):
				if i.has_method("Hurt"):
					if !i.dead:
						if !i.get_parent().is_in_group("player") && !i.is_in_group("player"):
							if !i.get_parent().is_in_group("PompNPC"):
								PossibleTargets.append(i.get_parent())
		if !PossibleTargets.is_empty():
			var target_group = PossibleTargets
			var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
			var return_node = target_group[0]
			for index in target_group.size():
				var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
				if get_closest == true && distance < distance_away:
					distance_away = distance
					return_node = target_group[index]
				elif get_closest == false && distance > distance_away:
					distance_away = distance
					return_node = target_group[index]
			return return_node
		else:
			animTrigger("Shrug")
			return null
	if item == false && itemUsable == false:
		var target_group = get_tree().get_nodes_in_group(group_name)
		var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
		var return_node = target_group[0]
		for index in target_group.size():
			var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
			if get_closest == true && distance < distance_away:
				distance_away = distance
				return_node = target_group[index]
			elif get_closest == false && distance > distance_away:
				distance_away = distance
				return_node = target_group[index]
		return return_node
	else:
		if group_name == "default" && item == true && itemUsable == false:
			for i in get_all_children(get_tree().get_root()):
				if "ItemID" in i:
					if !("DoNotTarget" in i):
						PossibleTargets.append(i.get_parent())
			if !PossibleTargets.is_empty():
				var target_group = PossibleTargets
				var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
				var return_node = target_group[0]
				for index in target_group.size():
					var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
					if get_closest == true && distance < distance_away:
						distance_away = distance
						return_node = target_group[index]
					elif get_closest == false && distance > distance_away:
						distance_away = distance
						return_node = target_group[index]
				return return_node
			else:
				animTrigger("Shrug")
				return null

		elif group_name == "default" && itemUsable == true:
			for i in get_all_children(get_tree().get_root()):
				if "itemMatch" in i:
					if !("DoNotTarget" in i):
						PossibleTargets.append(i.get_parent())
			if !PossibleTargets.is_empty():
				var target_group = PossibleTargets
				var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
				var return_node = target_group[0]
				for index in target_group.size():
					var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
					if get_closest == true && distance < distance_away:
						distance_away = distance
						return_node = target_group[index]
					elif get_closest == false && distance > distance_away:
						distance_away = distance
						return_node = target_group[index]
				return return_node
			else:
				animTrigger("Shrug")
				return null
		else:
			animTrigger("Shrug")
			return null

###################################
###
###################################
func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;

func animSet(triggername : String, toggle : bool = true):
	animTree["parameters/conditions/" + triggername] = toggle;

func get_all_children(in_node, array := []):
	if in_node != null:
		array.push_back(in_node)
		for child in in_node.get_children():
			array = get_all_children(child, array)
		return array


###################################
###I needed chatGPT to help me write this. I have brought dishonor to my family.
###################################
func find_rotation_to(node1 : Node3D,node2 : Node3D,degree = false):
	var pos1 = node1.global_transform.origin
	var pos2 = node2.global_transform.origin
	pos2.y = 2
	# Calculate the direction vector from node1 to node2 and normalize it
	var direction_to_node2 = (pos2 - pos1).normalized()
	var forward_vector = modelRoot.global_transform.basis.z.normalized()
	# Calculate the angle between the forward vector and the direction vector
	var angle = forward_vector.angle_to(direction_to_node2)
	# Use cross product to determine the angle's sign (relative to the Y-axis)
	var cross_product = forward_vector.cross(direction_to_node2)
	# Adjust angle based on the cross product's Y-component
	if cross_product.y < 0:
			angle = -angle
	# Convert the angle to degrees (if needed)
	var angle_degrees = rad_to_deg(angle)
	if(degree):
		return angle_degrees
	else:
		return angle


func _on_dialog_object_dialogue_active():
	running = false


func _on_dialog_object_dialogue_deactivated():
	if !HealthHandler.dead:
		running = true
