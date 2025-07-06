extends Area3D
@export var healthObject : Node3D
@export var HideNode : Node3D
@export var player : Node3D
@export var rotationRange : Vector2

func _on_area_entered(area):
	if healthObject != null:
		if healthObject.get_parent().visible:
			healthObject.Hurt(3)
			HideNode.hide()
			HideNode.process_mode = Node.PROCESS_MODE_DISABLED
