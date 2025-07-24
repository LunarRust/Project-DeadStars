extends Node
@export var DialogueBox : Node2D
@export var soundSource : AudioStreamPlayer3D
@export_category("Dialogic")
@export var Dialog_text : Node
@export var Dialog_name : Node
@export var PortraitContainer : Node
var Dialogic : Node
var PlayerUI : Node2D
var isTalking : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerUI = get_tree().get_first_node_in_group("UIPARENT")
	Dialogic = get_tree().get_first_node_in_group("Dialogic")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_SPACE):
		CloseDialogue()


func Touch():
	OpenDialogue()


func OpenDialogue():
	Dialog_text.reveal_text()
	DialogueBox.show()
	PlayerUI.hide()
	DialogueBox.modulate = Color.TRANSPARENT
	var tween : Tween = create_tween()
	tween.tween_property(DialogueBox,"modulate",Color.WHITE,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func CloseDialogue():
	DialogueBox.hide()
	PlayerUI.show()
	if soundSource != null:
		soundSource.stop()
	isTalking = false
