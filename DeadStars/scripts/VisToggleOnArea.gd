extends Area3D
@export var clayPerson : Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	clayPerson.process_mode = Node.PROCESS_MODE_DISABLED
	clayPerson.hide()


func _on_area_entered(area):
	if clayPerson != null:
		clayPerson.process_mode = Node.PROCESS_MODE_ALWAYS
		clayPerson.show()
