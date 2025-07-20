extends Node3D
var Children : Array

func _ready():
	Children = self.get_children()

func KillChildren():
	if Children.is_empty():
		Children = get_children()
	Children.shuffle()
	for i in Children:
		if i.has_node("HealthController"):
			await get_tree().create_timer(randf_range(0.3,1)).timeout
			i.get_node("HealthController").Hurt(999)
