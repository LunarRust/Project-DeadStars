extends Node3D
@export_category("DialogueSystem")
@export var npcName : String
@export_subgroup("Text values")
@export_multiline var Dialogue : Array[String] = ["[placeholder]"]
@export var DialogueVA : Array[AudioStream]
@export_multiline var LookDescription : Array[String] = ["[placeholder]"]
@export_multiline var TouchDescription : Array[String] = ["[placeholder]"]
@export_category("DialogueParameters")
@export var DoDialogue : bool = true
@export var DoLook : bool = true
@export var DoTouch : bool = true
@export var soundSource : AudioStreamPlayer3D
@export var ObjectRoot : Node3D
@export var DialogueSound : AudioStream
@export var faceSprite : Texture2D
var DialogueBox : Node2D
var isTalking : bool
var PlayerObject : Node
var PlayerHealthController : Node2D
var lookTarget : Vector3
var active : bool = false

@export_category("Physical parameters")
@export var looking : bool = true
@export var Distance : bool = true
@export var CloseDistance : float = 4
@export var DamageOnDialogue : bool = false
@export var DamageOnLook : bool = false
@export var DamageOnTouch : bool = false
@export var Damage : int = 1
var parentnode : Node3D
var ActionButtonMaster : Node
var RandNum : RandomNumberGenerator
var num : int
var enabled : bool = true

func _ready():
	RandNum = RandomNumberGenerator.new()
	DialogueBox = get_tree().get_first_node_in_group("DialogueBox")
	PlayerObject = get_tree().get_first_node_in_group("player")
	PlayerHealthController = get_tree().get_first_node_in_group("PlayerHealthHandler")
	ActionButtonMaster = get_tree().get_first_node_in_group("InteractionButtonKOMMaster")
	if DialogueBox != null:
		DialogueBox.DialogueClosed.connect(CloseDialogue)
	if ObjectRoot == null:
		ObjectRoot = self

	parentnode = self.get_parent()
	var vector : Vector3 = parentnode.global_position + parentnode.basis.z * 2
	lookTarget = Vector3(vector.x,self.global_position.y,vector.z)
	active = true


func _process(delta):
	if active:
		if looking:
			parentnode.look_at(lookTarget,Vector3.UP,true)
			if PlayerObject != null:
				if self.global_position.distance_to(PlayerObject.global_position) > CloseDistance && isTalking && Distance:
					CloseDialogue()

func OpenDialogue():
	if enabled:
		DialogueBox.show()
		DialogueBox.modulate = Color.TRANSPARENT
		var tween : Tween = create_tween()
		tween.tween_property(DialogueBox,"modulate",Color.WHITE,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func  DialogueProcessing():
	if enabled:
		if looking:
			var tween : Tween = create_tween()
			tween.tween_property(self,"lookTarget",Vector3(PlayerObject.position.x,self.global_position.y,PlayerObject.position.z),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		match ActionButtonMaster.interactionMode:
			1:
				if DoLook:
					num = RandNum.randi_range(0,LookDescription.size() - 1)
					DialogueBox.get_node("NameText").text = "Look"
					DialogueBox.get_node("MainText").text = LookDescription[num]
					DialogueBox.get_node("FaceSprite").texture = load("res://Sprites/Faces/Eye.png")
					OpenDialogue()
				if DamageOnLook:
					PlayerHealthController.notsostatichealth(Damage)

			2:
				if DoDialogue:
					num = RandNum.randi_range(0,Dialogue.size() - 1)
					if DialogueVA.size() - 1 >= num:
						soundSource.stream = DialogueVA[num]
						soundSource.play()
					else:
						if soundSource != null:
							soundSource.stream = null
					if DialogueVA.size() == 0:
						if soundSource != null:
							soundSource.stream = DialogueSound
							soundSource.pitch_scale = randf_range(0.8,1.2)
							soundSource.play()
					DialogueBox.get_node("NameText").text = npcName
					DialogueBox.get_node("MainText").text = Dialogue[num]
					DialogueBox.get_node("FaceSprite").texture = faceSprite
					OpenDialogue()
				if DamageOnDialogue:
					PlayerHealthController.notsostatichealth(Damage)

			3:
				if DoTouch:
					num = RandNum.randi_range(0,TouchDescription.size() - 1)
					DialogueBox.get_node("NameText").text = "Touch"
					DialogueBox.get_node("MainText").text = TouchDescription[num]
					DialogueBox.get_node("FaceSprite").texture = load("res://Sprites/Faces/Touch.png")
					OpenDialogue()
				if DamageOnTouch:
					PlayerHealthController.notsostatichealth(Damage)
		isTalking = true

func CloseDialogue():
	DialogueBox.hide()
	if soundSource != null:
		soundSource.stop()
	isTalking = false


func _on_health_controller_death():
	enabled = false
