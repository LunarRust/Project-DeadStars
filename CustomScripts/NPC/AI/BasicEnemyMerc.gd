extends CharacterBody3D

@export var nav_agent : NavigationAgent3D

var speed: float = 3
@export var MaxSpeed: float = 3
@export var ReTargetTime : float = 1

@export var TargetObject :Node3D

@export var anim : AnimationPlayer
@export var animTree : AnimationTree
@export var animAttackDelay : float = 1

@export var attackThreshold : float = 1.5
@export var attackPower : int = -1
@export var aggroRange : int = 10
@export var walkName = "Walk"
@export var attackName = "Attack"
@export var meleeAttack : bool = true

var timer : float = 0
var forwardVel
var velV2 : float
var MaxDistance : float = 1.5
var attackTimer : float
var attacking : bool
var active : bool = false
var distance
var HealthObject

func _ready():
	if (TargetObject == null):
		print("Ouchie wawa! There's no defined player object for this enemy to chase! Trying to find one now.")
		Target()
		active = false
	else:
		active = true
	pass


func Target():
	TargetObject = find_closest_or_furthest(self,"PlayerAlly")
	if TargetObject != null:
		if TargetObject.is_in_group("player"):
			HealthObject = self.get_tree().get_first_node_in_group("PlayerHealthHandler")
		else:
			HealthObject = TargetObject.get_node("HealthController")

func _physics_process(delta):
	timer += delta
	if (active):
		active_handling(delta)
	if TargetObject == null:
		Target()
	elif HealthObject != null:
		if HealthObject.dead:
			Target()
		else:
			active = true
	else:
		active = true
	if timer >= ReTargetTime:
		Target()
		timer = 0


func active_handling(delta):
	distance = global_position.distance_to(TargetObject.position)
	if (global_position.distance_to(TargetObject.global_position) < aggroRange && !attacking):
		if (anim != null):
			anim.play(walkName)
		attacking = true
	if (global_position.distance_to(TargetObject.global_position) > 1.5 && attacking):
		handle_Move(delta)
	if (global_position.distance_to(TargetObject.global_position) < 3.5):
		attackTimer += 1 * delta
	if (attackTimer > attackThreshold && attacking && meleeAttack):
		Attack()
		attackTimer = 0

####ANIMATION HANDLING#############
###Calculations based on velocity and Distance to nav target
### Uses these values to determine animation blend positions
###################################
	if (position.distance_to(TargetObject.position) < MaxDistance + 1.5):
		speed = (nav_agent.distance_to_target() - 1)
	else:
		speed = (nav_agent.distance_to_target()) + 0.286
	if speed >= MaxSpeed:
		speed = MaxSpeed
	if (nav_agent.distance_to_target() < MaxDistance + 7 && nav_agent.distance_to_target() > MaxDistance):
		speed = lerp(speed,0.0,delta)
	if (global_position.distance_to(TargetObject.global_position) < 1.5):
		velV2 = lerp(velV2,0.0,delta)
	else:
		forwardVel = abs(velocity.dot(transform.basis.z)) + abs(velocity.dot(transform.basis.x))
		velV2 = lerp(velV2,forwardVel - 0.5,delta * 2)
	if animTree != null:
		animTree["parameters/Normal/blend_position"] = velV2



func update_target_location(target_location):
	nav_agent.target_position = target_location

func handle_Move(delta : float):

	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	var lookTarget = Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z)
	if (current_location != next_location && velocity != Vector3.ZERO && lookTarget != global_position):
		look_at(Vector3(lookTarget), Vector3.UP, true)

	#look_at(Vector3(TargetObject.global_position.x,global_position.y,TargetObject.global_position.z), Vector3.UP, true);

	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	update_target_location(TargetObject.global_position)

func Attack():
	if (animTree != null):
		animTrigger(attackName)
	else:
		anim.play(attackName)

	if (global_position.distance_to(TargetObject.global_position) < 2.5):
		await get_tree().create_timer(animAttackDelay).timeout
		HealthObject.changeHealth(attackPower)
	if (animTree == null):
		anim.play(walkName)
	pass


func find_closest_or_furthest(node: Object,group_name = "PlayerAlly",get_closest:= true) -> Object:
	@warning_ignore("unassigned_variable")
	var PossibleTargets : Array
	if group_name == "PlayerAlly":
		var target_group = get_tree().get_nodes_in_group(group_name)
		var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
		var return_node = target_group[0]
		for index in target_group.size():
			if target_group[index].is_in_group("player"):
				HealthObject = self.get_tree().get_first_node_in_group("PlayerHealthHandler")
			else:
				HealthObject = target_group[index].get_node("HealthController")
				if HealthObject != null:
					if !HealthObject.dead:
						var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
						if get_closest == true && distance < distance_away:
							distance_away = distance
							return_node = target_group[index]
						elif get_closest == false && distance > distance_away:
							distance_away = distance
							return_node = target_group[index]
		return return_node
	else:
		return null

func get_all_children(in_node, array := []):
	if in_node != null:
		array.push_back(in_node)
		for child in in_node.get_children():
			array = get_all_children(child, array)
		return array

func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;
