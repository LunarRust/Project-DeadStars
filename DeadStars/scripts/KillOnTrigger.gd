extends Node
@export var healthObject : Array[Node3D]
@export var HideNode : Node3D
@export var player : Node3D
@export var rotationRange : Vector2


func Kill():
	if healthObject != null:
		for i in healthObject:
			if i.get_parent().visible:
				i.Hurt(99999)
			if HideNode != null:
				HideNode.hide()
				HideNode.process_mode = Node.PROCESS_MODE_DISABLED
