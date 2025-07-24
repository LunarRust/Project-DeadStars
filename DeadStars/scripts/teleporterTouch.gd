extends Node
@export var destination : Vector3
@export var colorRect : ColorRect
@export var PlayerObject : Node3D
@export var DoColorWipe : bool = true


func Touch():
	Teleport()



func Teleport():
	if DoColorWipe:
		colorRect.color = Color.WHITE
		var tween : Tween = create_tween()
		tween.tween_property(colorRect,"color",Color.TRANSPARENT,4.0)
	PlayerObject.position = destination + Vector3.UP
	PlayerObject.newPos = destination + Vector3.UP
