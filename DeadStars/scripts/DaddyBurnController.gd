extends Node
@export var FireAnimPlayer : AnimationPlayer
@export var Daddy1: Node3D
@export var Daddy2 : Node3D
@export var ChildrenKiller : Node3D
@export var CameraMover : StaticBody3D
@export var RockWall : StaticBody3D
@export var RockPile : StaticBody3D
@export var RockCamTrigger : Area3D
var CameraShaker

# Called when the node enters the scene tree for the first time.
func _ready():
	CameraShaker = get_tree().get_first_node_in_group("CameraShake")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_F6):
		Begin()


func Begin():
	RockCamTrigger.Enabled = true
	RockPile.position.y =- 4.525
	if RockWall != null:
		RockWall.get_node("HealthControllerHeHaa").Hurt(999)
	CameraMover.get_node("Behavior").Touch()
	FireAnimPlayer.Anim_Play()
	if Daddy1 != null:
		Daddy1.queue_free()
	Daddy2.show()
	ChildrenKiller.KillChildren()
	await get_tree().create_timer(2.1).timeout
	CameraShaker.Shake(0.2,0.09)
	await get_tree().create_timer(5).timeout
	CameraMover.get_node("Behavior").ReturnCamera()
