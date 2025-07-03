extends Area3D
@export var destination : Vector3
@export var colorRect : ColorRect
@export var PlayerObject : Node3D

func Teleport(area : Area3D):
	if area.name == "PlayerArea":
		colorRect.color = Color.WHITE
		var tween : Tween = create_tween()
		tween.tween_property(colorRect,"color",Color.TRANSPARENT,4.0)
		PlayerObject.position = destination + Vector3.UP
		PlayerObject.newPos = destination + Vector3.UP
