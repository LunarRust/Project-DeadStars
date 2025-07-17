extends Button

@export var destination: String
var loadScene: PackedScene
@export var sceneLoader: String = "res://DeadStars/scenes/TSLC_Venus.tscn"

func _ready():
	loadScene = load(sceneLoader)
	pass


func _pressed():

	SceneLoader.DestinationScene = destination
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass
