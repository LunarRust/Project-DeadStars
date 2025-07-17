extends Node
@export var AnimTree : AnimationTree
@export var DialogueSystem : Node3D
@export var instantiator  : Node3D
@export var SoundPlayer : AudioStreamPlayer3D
@export var OpenSoundEffect : AudioStream
@export_category("parameters")
@export var DoSpawn : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Hurt():
	DialogueSystem.CloseDialogue()


func Die():
	self.get_parent().get_node("Col").disabled = true
	animTrigger("die")
	if DoSpawn:
		instantiator.Packload()


func Open():
	self.get_parent().get_node("Col").disabled = true
	SoundPlayer.stream = OpenSoundEffect
	SoundPlayer.play()
	animTrigger("open")
	if DoSpawn:
		instantiator.Packload()


func animTrigger(triggername : String):
	AnimTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	AnimTree["parameters/conditions/" + triggername] = false;
