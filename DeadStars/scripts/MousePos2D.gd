extends Node2D

var mousepos2D
func _process(delta):
	mousepos2D = get_viewport().get_global_mouse_position()
