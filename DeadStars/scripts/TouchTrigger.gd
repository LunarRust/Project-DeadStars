extends Node
signal touched
@export var OnlyOnce : bool = false
var used : bool = false

func Touch():
	if used == false:
		touched.emit()
		if OnlyOnce:
			used = true
