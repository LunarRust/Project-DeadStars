extends Area3D


var loadScene: PackedScene
@export var destination: String
@export var enabled : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = load(destination)
	if !enabled:
		self.process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


func Enable():
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func _load():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass


func _on_area_entered(area):
	_load()
	pass # Replace with function body.
