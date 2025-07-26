extends Node3D
@export_category("LR Dialog System")
@export var ResetOnExit : bool = true
@export var LoopText : bool = false
@export var ShopSystem : bool = false
@export_category("Dialogue Options")
@export_multiline var Dialogue : Array[String] = ["No text provided."]
@export_multiline var Dialogue2 : Array[String] = ["No text provided."]
@export_multiline var Dialogue3 : Array[String] = ["No text provided."]
@export_multiline var Dialogue4 : Array[String] = ["No text provided."]
@export var NPCName : String = " "
@export var TalkSound : AudioStream = preload("res://Sounds/DNAfail.ogg") as AudioStream
@export var FaceSprite : Texture2D = preload("res://Sprites/Caldman.png") as Texture2D
@export_category("Shop Options")
@export var ShopController : Node2D
@export var NPCInv : Inventory
@export var NPCInvDisplay : CtrlInventoryGridEx
@export var ShopEnabled : bool = false
@export_category("Assignments")
@export var MainText : RichTextLabel
@export var NameText : RichTextLabel
var DialogueBox : Sprite2D
@export var soundSource : AudioStreamPlayer3D
@export var Sprite : Sprite2D
var DialogUI : CanvasLayer
var DialogInterface : Node2D
var PompFriend : Node2D
var MenuGrabber : Node
var EntryNum : int = 1
var PlayerUI : Node2D
var NPCParent : CharacterBody3D
var isTalking : bool = false
var enabled : bool = true
var DefaultText : Array[String] = ["No text provided."]

signal DialogueActive
signal DialogueDeactivated

###
###TODO: This whole thing is dogshit.
### Either completley rewrite, or remove.
###

func _ready():
	DefaultText = Dialogue
	await get_tree().create_timer(0.1).timeout
	DialogUI = get_tree().get_first_node_in_group("NewDialogUI")
	PompFriend = get_tree().get_first_node_in_group("PompFriendParent")
	PlayerUI = get_tree().get_first_node_in_group("UIPARENT")
	NPCParent = self.get_parent().get_parent()
	MenuGrabber = get_node("CamGrabber/Behavior")
	get_node("UI/ModeSelectInterface/ShopController/ScoreEntry2").text = NPCName
	DialogInterface = DialogUI.get_node("DialogInterface")
	DialogueBox = DialogInterface.get_node("DialogueParent/DialogueBox")
	ShopController = DialogUI.get_node("ModeSelectInterface")
	NPCInvDisplay = DialogUI.get_node("ModeSelectInterface/ShopController/TextureRect/InvDisplay")
	MainText = DialogueBox.get_node("TextParent/MainText")
	NameText = DialogueBox.get_node("TextParent/NameText")
	MainText.text = Dialogue[0]

	get_tree().get_first_node_in_group("ChangeText2").connect("pressed",DialogSet2)
	get_tree().get_first_node_in_group("ChangeText3").connect("pressed",DialogSet3)
	get_tree().get_first_node_in_group("ChangeText4").connect("pressed",DialogSet4)
	get_tree().get_first_node_in_group("NextTextButton").connect("pressed",Next)

func Show():
	pass

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) || Input.is_key_pressed(KEY_SPACE) || Input.is_joy_button_pressed(0,JOY_BUTTON_B) && !PlayerUI.visible:
		CloseDialogue()

func DialogueProcessing():
	OpenDialogue()

func OpenDialogue(Reset : bool = true):
	if enabled:
		PompFriend.hide()
		DialogueActive.emit()
		MenuGrabber.Touch()
		NPCInvDisplay.inventory_path = NPCInv.get_path()
		if ResetOnExit:
			MainText.text = Dialogue[0]
			EntryNum = 1
		Sprite.texture = FaceSprite
		NameText.text = NPCName
		DialogueBox.show()
		if ShopEnabled:
			OpenShop()
		soundSource.stream = TalkSound
		soundSource.play()
		PlayerUI.hide()
		DialogueBox.modulate = Color.TRANSPARENT
		var tween : Tween = create_tween()
		tween.tween_property(DialogueBox,"modulate",Color.WHITE,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		isTalking = true

func OpenShop():
	NPCInvDisplay.inventory_path = NPCInv.get_path()
	ShopController.show()


func CloseShop():
	ShopController.hide()

func CloseDialogue():
	Dialogue = DefaultText
	PompFriend.show()
	DialogueDeactivated.emit()
	DialogueBox.hide()
	if ShopEnabled:
		CloseShop()
	PlayerUI.show()
	MenuGrabber.ReturnCamera()
	if soundSource != null:
		soundSource.stop()
	isTalking = false

func Next():
	NextSet(EntryNum)
	soundSource.play()
	EntryNum += 1
	if EntryNum >= Dialogue.size() + 1:
		EntryNum = 0
		CloseDialogue()

func NextSet(index : int = 0):
	if index >= Dialogue.size():
		index = 0
	MainText.text = Dialogue[index]


func _on_health_controller_death():
	enabled = false

func DialogSet2():
	if isTalking:
		Dialogue = Dialogue2
		OpenDialogue(false)
func DialogSet3():
	if isTalking:
		Dialogue = Dialogue3
		OpenDialogue(false)
func DialogSet4():
	if isTalking:
		Dialogue = Dialogue4
		OpenDialogue(false)

func _on_next_text_button_pressed():
	NPCParent.animTrigger("DialogueTalk")


func _on_NewText1_pressed():
	NPCParent.animTrigger("DialogueTalk2")
