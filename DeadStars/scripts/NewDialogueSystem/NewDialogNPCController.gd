extends Node3D
@export var NPCName : String = "N/A"
@export var Dialogue : Array[String] = ["No text provided."]
@export_group("Dialogue2")
@export var Dialogue2ButtonName : String
@export var Dialogue2 : Array[String]
@export_group("Dialogue3")
@export var Dialogue3ButtonName : String
@export var Dialogue3 : Array[String]
@export_group("Dialogue4")
@export var Dialogue4ButtonName : String
@export var Dialogue4 : Array[String]
@export_category("Assignments")
@export var TalkSound : AudioStream
@export var CharSprite : Texture2D
@export var NPCInv : Inventory
@export var DoExpandedInterface : bool = false
@export var Camera : Camera3D
var CamGrabber
var DialogueSound
var HealthController
var Behavior

func _ready():
	CamGrabber = self.get_node("CamGrabber/Behavior")
	DialogueSound = self.get_node("DialogueSound")
	HealthController = self.get_parent().get_node("HealthController")
	Behavior = self.get_parent().get_node("Behavior")
	CamGrabber.MenuCam = Camera

func StopTalking():
	if !HealthController.dead:
		Behavior.StopTalking()
		self.get_parent().running = true

func Talk(AltAnim : bool = false):
	if !HealthController.dead:
		self.get_parent().running = false
		DialogueSound.pitch_scale = randf_range(0.8,1.2)
		DialogueSound.stream = TalkSound
		DialogueSound.play()
		if !AltAnim:
			Behavior.AnimTrigger("DialogueTalk")
		else:
			Behavior.AnimTrigger("DialogueTalk2")


func DialogueProcessing():
	pass
