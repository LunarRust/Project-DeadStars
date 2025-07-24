extends AnimationPlayer

@export var destination: String
var loadScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():

	loadScene = load(destination)



func _load():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass


func _on_animation_finished(anim_name:StringName):
	print(anim_name)
	_load()
	pass # Replace with function body.
