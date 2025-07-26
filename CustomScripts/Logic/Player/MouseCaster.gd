class_name MouseCaster
extends Node3D
@export var RCS : Node3D
@export var PlayerAnim : AnimationTree
@export var HammerAnim : AnimationPlayer
@export var HurtFor : int
@export var AttackDelay : float = 1
@export var SoundSource : AudioStreamPlayer
@export_category("Settings")
@export var DoCamShake : bool = true
var CastAllowed : bool = true
var active : bool = false
var space_state
var canAttack : bool = true
var cam
var mousepos
var CurrentIntersectedObject
var interactionButtonKOM
var TouchedObject
var ViewButton = preload("res://Scripts/ViewButton.cs")
@export var WooshSound : AudioStream = preload("res://Sounds/Woosh.ogg") as AudioStream
@export var ImpactSound : AudioStream = preload("res://Sounds/Impact.ogg") as AudioStream
@export var CastFailSound : AudioStream = preload("res://Sounds/DNAchange.ogg") as AudioStream

signal BehaviorNode(node)
signal TalkNode(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	interactionButtonKOM = get_tree().get_first_node_in_group("InteractionButtonKOMMaster")
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if active:
		space_state = get_world_3d().direct_space_state
		cam = get_viewport().get_camera_3d()
		mousepos = get_viewport().get_mouse_position()
		if mousepos == null:
			mousepos = Vector2(0,0)
		if RCS.get_mouse_world_position(space_state,cam,mousepos) != null:
			self.global_position = RCS.get_mouse_world_position(space_state,cam,mousepos)
		CurrentIntersectedObject = RCS.get_raycast_hit_object(space_state,cam,mousepos)

func Cast():
	if CastAllowed:
		var node : Node
		var zDepth : float
		zDepth = 2
		var from : Vector3 = cam.project_ray_origin(mousepos)
		var to = cam.project_position(mousepos,zDepth)
		var physicsRayQueryParameters3D : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from,to)
		physicsRayQueryParameters3D.hit_back_faces = false
		var dictionary : Dictionary = space_state.intersect_ray(physicsRayQueryParameters3D)
		print_rich("[color=red]" + str(dictionary) + "[/color]")
	###TODO: Reimplement these col checks with new IdentifyCollider() func
		if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("DialogueSystem"):
			(dictionary["collider"] as CollisionObject3D).get_node("DialogueSystem").DialogueProcessing()
		if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("Behavior"):
			node = (dictionary["collider"] as CollisionObject3D).get_node("Behavior")
		match  interactionButtonKOM.interactionMode:
			3:
				if !dictionary.is_empty():
					if node != null:
						if node.has_method("Touch"):
							animTrigger("Touch")
							node.Touch()
							BehaviorNode.emit(node)
							print_rich("Touched object is: [color=red]" + str(node) + "[/color]")

			4:
				if canAttack:
					canAttack = false
					animTrigger("Attack")
					HammerAnim.stop()
					HammerAnim.play("Attack")
					SoundSource.stream = WooshSound
					SoundSource.play()
					await get_tree().create_timer(0.15000000596046448).timeout
					if !dictionary.is_empty():
						if (dictionary["collider"] as CollisionObject3D).has_node("HealthController"):
							var health : Node = (dictionary["collider"] as CollisionObject3D).get_node("HealthController")
							health.Hurt(HurtFor,DoCamShake)
							print("Hitting DeadStars creature")

						elif (dictionary["collider"] as CollisionObject3D).has_node("HealthHandler"):
							var health : Node = (dictionary["collider"] as CollisionObject3D).get_node("HealthHandler")
							health.Hurt(HurtFor)
							print("Hitting base game creature")



						else:
							SoundSource.stream = ImpactSound
							SoundSource.play()
							print("Hitting object")

						if node != null:
							if node.has_method("Hurt"):
								node.Hurt()
								print_rich("Attacked object is: [color=red]" + str(node) + "[/color]")


					await get_tree().create_timer(AttackDelay).timeout
					canAttack = true
			2:
				var DialogueNode
				if IdentifyCollider(dictionary,"AdvancedDialogueSystem") != null:
					DialogueNode = IdentifyCollider(dictionary,"AdvancedDialogueSystem")
					DialogueNode.DialogueProcessing()
					TalkNode.emit(DialogueNode)
					if node != null:
						if node.has_method("Talk"):
							animTrigger("Talk")
							BehaviorNode.emit(node)
							node.Talk()
				else:
					print("No AdvancedDialogueSystem identified.")
			1:
				if !dictionary.is_empty():
					if node != null:
						if node.has_method("Look"):
							node.Look()
		TouchedObject = CurrentIntersectedObject


func IdentifyCollider(dictionary : Dictionary,NodeName : String):
	var node
	if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node(NodeName):
		node = (dictionary["collider"] as CollisionObject3D).get_node(NodeName)
		return node
	else:
		return null

func ItemCast(item):
	var zDepth : float
	zDepth = 2
	var from : Vector3 = cam.project_ray_origin(mousepos)
	var to = cam.project_position(mousepos,zDepth)
	var physicsRayQueryParameters3D : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from,to)
	physicsRayQueryParameters3D.hit_back_faces = false
	var dictionary : Dictionary = space_state.intersect_ray(physicsRayQueryParameters3D)
	print_rich("[color=red]" + str(dictionary) + "[/color]")
	print_rich("Casting with:[color=red] " + item.prototype_id + "[/color]")
	#print(str(item.get_property("health")) + " type: " + str(type_string(item.get_property("health"))))
	if item.get_property("health") is float || item.get_property("health") is int:
		if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("HealthController"):
			var node : Node = (dictionary["collider"] as CollisionObject3D).get_node("HealthController")
			if node.has_method("Item"):
				node.Item(item)
				return true
		else:
			SoundSource.stream = CastFailSound
			SoundSource.play()
			return false
	if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("Behavior"):
		var node : Node = (dictionary["collider"] as CollisionObject3D).get_node("Behavior")
		if node.has_method("Item"):
			node.Item(item.prototype_id)
			return true
	else:
		return false


func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		mousepos = event.position
		Cast()

func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array

func animTrigger(triggername : String):
	PlayerAnim["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	PlayerAnim["parameters/conditions/" + triggername] = false;


func _on_new_dialog_ui_dialogue_active():
	CastAllowed = false


func _on_new_dialog_ui_dialogue_deactivated():
	CastAllowed = true
