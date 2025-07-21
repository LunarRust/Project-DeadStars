extends Node
@export var animPlayer : AnimationPlayer
@export var PlayerObject : Node2D
@export var PompyAnim : Node3D
@export var PlayerCamera : Camera3D
@export var CineCamera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	ShowTime()


func ShowTime():
	CineCamera.make_current()

	await get_tree().create_timer(4.2).timeout
	PlayerCamera.make_current()
	PompyAnim.hide()
	PlayerObject.show()
