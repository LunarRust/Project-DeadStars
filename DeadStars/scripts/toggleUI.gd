extends CheckButton
@export var UIParentHide : Node2D
@export var UIParentShow: Node2D


func _on_pressed():
	if button_pressed:
		UIParentHide.hide()
		UIParentShow.show()
		get_child(0).play()
	else:
		UIParentHide.show()
		UIParentShow.hide()
		get_child(0).play()
