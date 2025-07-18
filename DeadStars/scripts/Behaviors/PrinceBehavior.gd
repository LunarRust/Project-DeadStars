@icon("res://DeadStars/sprites/UI/Prince_Smile2.png")

extends Node
var SignalBusKOM
@export var anim : AnimationTree
@export var PompAI : Node3D
@export var dialogue : Node3D
@export var HealthController : Node3D
@export_category("Parameters")
@export var follow : bool
#@export var PlayerObject : MeshInstance3D

var SignalBusInnout
var InnoutExists : bool = false
var InteractionButton = load("res://Scripts/InteractionButton.cs")
@onready var DialogueBox = get_tree().get_first_node_in_group("DialogueBox")
func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		SignalBusKOM = player.get_node("KOMSignalBus")
	if get_tree().get_first_node_in_group("InnOutSignalBus") != null:
		SignalBusInnout = get_tree().get_first_node_in_group("InnOutSignalBus")
		InnoutExists = true
	else:
		InnoutExists = false

func StartAttack(name : StringName):
	print(name)
	if name == "Angry":
		PompAI.set("Attacking", true)

func Look():
	AnimTrigger("Shrug")

func Touch(AmNpc = false):
	AnimTrigger("Touch")

func Talk(DoDiolouge : bool = true):
	AnimTrigger("Talk")
	if DoDiolouge:
		dialogue.DialogueProcessing()

func Hurt():
	if HealthController.HP >= 1:
		AnimTrigger("Hurt")
	if follow:
		#PompAI.set("hurt", true)
		DialogueBox.hide()
		await get_tree().create_timer(1).timeout
		#PompAI.set("hurt", false)
		if InnoutExists == true:
			SignalBusInnout.emit_signal("GameOver")



func AnimTrigger(triggerName : String):
	anim["parameters/conditions/" + triggerName] = true;
	await get_tree().create_timer(0.1).timeout
	anim["parameters/conditions/" + triggerName] = false;


#func _process(delta):
	#if InteractionButton.get_propertylist("interactionMode") != 1:
		#pass
