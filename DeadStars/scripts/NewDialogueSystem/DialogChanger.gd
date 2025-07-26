extends TextureButton
@export_multiline var Dialogue : Array[String] = ["No text provided."]
@export var DialogParent : Node3D

func _on_pressed():
	pass
	#self.DialogParent.Dialogue = Dialogue
	#self.DialogParent.OpenDialogue(false)
