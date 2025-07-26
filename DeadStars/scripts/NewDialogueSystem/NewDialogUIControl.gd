extends CanvasLayer
@export var PompFriend : Node2D
@export var PlayerUI : Node2D
@export var ShopEnabled : bool = false
@export var UISoundSource : AudioStreamPlayer
var LastNPCDialogNode
var Dialogue : Array[String]
var DialogInterface : Node2D
var DialogueBox : Sprite2D
var ShopController : Node2D
var ModeSelectInterface : Node2D
var NPCInvDisplay : CtrlInventoryGridEx
var MenuGrabber
var NPCInv : Inventory
var MainText : RichTextLabel
var NameText : RichTextLabel
var DefaultText : Array[String] = ["No text provided."]
var EntryNum : int = 1
var FaceSprite : Sprite2D
var DoExpandedInterface : bool = false
var InvNameText : Label
var NPCHPText : Label
###Buttons
var NextTextButton
var InvButton
var NewDialog0
var NewDialog1
var NewDialog2
var NewDialog3
###Extra Dialogs
var Dialogue2
var Dialogue3
var Dialogue4

###Signals
signal DialogueActive
signal DialogueDeactivated

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogInterface = self.get_node("DialogInterface")
	DialogueBox = DialogInterface.get_node("DialogueParent/DialogueBox")
	ShopController = self.get_node("ModeSelectInterface/ShopController")
	ModeSelectInterface = self.get_node("ModeSelectInterface")
	NPCInvDisplay = self.get_node("ModeSelectInterface/ShopController/TextureRect/InvDisplay")
	NewDialog3 = ModeSelectInterface.get_node("VBoxContainer/ScoreContainer/UIParent/TextureButton")
	NewDialog2 = ModeSelectInterface.get_node("VBoxContainer/ScoreContainer3/UIParent/TextureButton")
	NewDialog1 = ModeSelectInterface.get_node("VBoxContainer/ScoreContainer4/UIParent/TextureButton")
	InvButton = ModeSelectInterface.get_node("VBoxContainer/ScoreContainer2/UIParent/TextureButton")
	NPCInvDisplay = ShopController.get_node("TextureRect/InvDisplay")
	NextTextButton = DialogueBox.get_node("TextParent/NextTextButton")
	MainText = DialogueBox.get_node("TextParent/MainText")
	NameText = DialogueBox.get_node("TextParent/NameText")
	NPCHPText = DialogueBox.get_node("TextParent/HP_Number")
	FaceSprite = DialogueBox.get_node("FaceSprite")
	InvNameText = ShopController.get_node("ScoreEntry2")
	NewDialog1.connect("pressed",DialogSet2)
	NewDialog2.connect("pressed",DialogSet3)
	NewDialog3.connect("pressed",DialogSet4)
	DialogueBox.get_node("TextParent/NextTextButton").connect("pressed",Next)


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) || Input.is_key_pressed(KEY_SPACE) || Input.is_joy_button_pressed(0,JOY_BUTTON_B) && !PlayerUI.visible:
		CloseDialogue()

func OpenDialogue(Reset : bool = true):
	PompFriend.hide()
	DialogueActive.emit()
	MenuGrabber.Touch()
	if Reset:
		MainText.text = Dialogue[0]
		EntryNum = 1

	DialogueBox.show()
	if DialogInterface:
		ModeSelectInterface.show()

	PlayerUI.hide()
	DialogueBox.modulate = Color.TRANSPARENT
	var tween : Tween = create_tween()
	tween.tween_property(DialogueBox,"modulate",Color.WHITE,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#isTalking = true

func CloseDialogue():
	Dialogue = DefaultText
	PompFriend.show()
	DialogueDeactivated.emit()
	DialogueBox.hide()
	if DoExpandedInterface:
		ModeSelectInterface.hide()
	PlayerUI.show()
	if MenuGrabber != null:
		MenuGrabber.ReturnCamera()
	if LastNPCDialogNode != null:
		LastNPCDialogNode.StopTalking()

func DialogSet2():
	Dialogue = Dialogue2
	MainText.text = Dialogue[0]
	OpenDialogue(false)
	LastNPCDialogNode.Talk(true)
func DialogSet3():
	Dialogue = Dialogue3
	MainText.text = Dialogue[0]
	LastNPCDialogNode.Talk(true)
	OpenDialogue(false)
func DialogSet4():
	Dialogue = Dialogue4
	MainText.text = Dialogue[0]
	LastNPCDialogNode.Talk(true)
	OpenDialogue(false)

	#isTalking = false


func Next():
	NextSet(EntryNum)
	UISoundSource.play()
	EntryNum += 1
	if EntryNum >= Dialogue.size() + 1:
		EntryNum = 0
		CloseDialogue()
	else:
		LastNPCDialogNode.Talk()

func NextSet(index : int = 0):
	if index >= Dialogue.size():
		index = 0
	MainText.text = Dialogue[index]

func NPCAssignments(node : Variant):
	FaceSprite.texture = node.CharSprite
	NameText.text = node.NPCName
	InvNameText.text = node.NPCName
	NPCInvDisplay.inventory_path = node.NPCInv.get_path()
	MenuGrabber = node.CamGrabber
	DoExpandedInterface = node.DoExpandedInterface
	if !node.Dialogue.is_empty():
		Dialogue = node.Dialogue
	if !node.Dialogue2.is_empty():
		Dialogue2 = node.Dialogue2
		NewDialog3.get_parent().get_node("ScoreEntry").text = node.Dialogue2ButtonName
		NewDialog3.get_parent().show()
	else:
		NewDialog1.get_parent().hide()
	if !node.Dialogue3.is_empty():
		Dialogue3 = node.Dialogue3
		NewDialog3.get_parent().get_node("ScoreEntry").text = node.Dialogue3ButtonName
		NewDialog3.get_parent().show()
	else:
		NewDialog2.get_parent().hide()
	if !node.Dialogue4.is_empty():
		Dialogue4 = node.Dialogue4
		NewDialog3.get_parent().get_node("ScoreEntry").text = node.Dialogue4ButtonName
		NewDialog3.get_parent().show()
	else:
		NewDialog3.get_parent().hide()

	NPCHPText.text = str(node.HealthController.HP)


func _on_mouse_caster_find_talk_node(node):
	if !node.HealthController.dead:
		NPCAssignments(node)
		LastNPCDialogNode = node
		OpenDialogue()
		node.Talk()
