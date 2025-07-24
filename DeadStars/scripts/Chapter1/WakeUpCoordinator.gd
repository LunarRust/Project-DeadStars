extends Node
@export var animPlayer : AnimationPlayer
@export var PlayerObject : Node2D
@export var PlayerObject3D : Node3D
@export var PompyAnim : Node3D
@export var PlayerCamera : Camera3D
@export var CineCamera : Camera3D
@export var WakeUpCamera : Camera3D
@export var WakeUpCamAnimator : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	ShowTime()


func ShowTime():
	CineCamera.make_current()
	PlayerObject3D.hide()

	await get_tree().create_timer(3.8).timeout
	WakeUpCamAnimator.play("CamToBed")



func _on_cam_animator_1_animation_finished(anim_name):
	await get_tree().create_timer(0.1).timeout
	WakeUpCamera.make_current()
	animPlayer.play("CameraGetOutOfBed")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "CameraGetOutOfBed":
		PompyAnim.hide()
		PlayerObject3D.show()
		PlayerObject.show()
		PlayerCamera.make_current()
