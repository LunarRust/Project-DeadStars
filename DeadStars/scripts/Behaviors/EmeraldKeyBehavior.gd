extends Node
@export var sigil : Sprite3D
@export var model : Node3D
@export var soundSource : AudioStreamPlayer3D
@export var light : OmniLight3D
signal KeyTaken
var used : bool = false

func Touch():
	if !used:
		used = true
		GetKey()

func GetKey():
	soundSource.play()
	var tween : Tween = create_tween()
	tween.tween_property(sigil,"scale",Vector3.ONE,2.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(3.0).timeout
	KeyTaken.emit()
	var newtween : Tween = create_tween()
	newtween.tween_property(model,"scale",Vector3.ZERO,2.0).set_trans(Tween.TRANS_SINE)
	var lightTween : Tween = create_tween()
	lightTween.tween_property(light,"light_energy",0,2.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(3.0).timeout
	get_parent().queue_free()
