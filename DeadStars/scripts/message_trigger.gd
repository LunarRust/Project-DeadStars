extends Area3D
@export var hideMessage : bool
var DialogueBox : Sprite2D
@export var Name : String
var used : bool = false
@export_multiline var Message : String
@export var faceSprite : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueBox = get_tree().get_first_node_in_group("DialogueBox")

func _on_area_entered(area):
	if DialogueBox != null:
		if !used:
			if hideMessage:
				print("Entered a Hide message node!")
				DialogueBox.hide()
				used = true
			else:
				print("Entered a Message node!")
				ShowMessage()
				used = true
	else:
		print("ERROR. DialogueBox not found!")

func ShowMessage():
	if DialogueBox != null:
		DialogueBox.get_node("NameText").text = Name
		DialogueBox.get_node("MainText").text = Message
		DialogueBox.get_node("FaceSprite").texture = faceSprite
		DialogueBox.show()
		DialogueBox.modulate = Color.TRANSPARENT
		var tween : Tween = create_tween()
		tween.tween_property(DialogueBox,"modulate",Color.WHITE, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(2.0).timeout
		queue_free()
	else:
		print("ERROR. DialogueBox not found!")
