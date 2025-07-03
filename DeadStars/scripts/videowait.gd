extends Node


@export var Destination : String
@export var transition : bool = false
@export var transitionTime : float = 5
@export var skippable : bool = false

func _changeScene():
	if (transition):
		Fade.crossfade_prepare(transitionTime,"WeirdWipe",false,false)
		get_tree().change_scene_to_packed(load(Destination) as PackedScene)
		Fade.crossfade_execute()
	else:
		get_tree().change_scene_to_packed(load(Destination) as PackedScene)
	pass # Replace with function body.

func _on_video_stream_player_finished():
	_changeScene()

func _input(_event):
	if ((Input.is_key_pressed(KEY_SPACE)||Input.is_action_just_pressed("ControllerAction")) && skippable):
		print("Skipping Cutscene")
		_changeScene()
