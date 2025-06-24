extends Node3D
@export var AnimPlayer : AnimationPlayer
@export var AnimName : String

func _on_trigger_volume_volume_been_entered():
	AnimPlayer.play(AnimName)
	AnimPlayer.active = true
