extends Node
@export var AnimTree : AnimationTree
@export var DialogueSystem : Node3D
@export var instantiator  : Node3D
@export var SoundPlayer : AudioStreamPlayer3D
@export var OpenSoundEffect : AudioStream
@export_category("parameters")
@export var DoSpawn : bool = true

var SpawnTimer : float = 0
@export var MaxSpawnTime : float = 5
var hasSpawned : bool = false
var dead : bool = false
var closed : bool = true

func _process(delta):
	if SpawnTimer <= MaxSpawnTime:
		SpawnTimer += delta * 1

func Hurt():
	DialogueSystem.CloseDialogue()


func Die():
	self.get_parent().get_node("Col").disabled = true
	dead = true
	animSet("die")
	if DoSpawn && hasSpawned == false:
		instantiator.Packload()


func Open():
	if SpawnTimer >= MaxSpawnTime && !dead:
		closed = false
		self.get_parent().get_node("Col").disabled = true
		SoundPlayer.stream = OpenSoundEffect
		SoundPlayer.play()
		animTrigger("open")
		if DoSpawn:
			SpawnTimer = 0
			instantiator.Packload()
			hasSpawned = true
			await get_tree().create_timer(3.0).timeout
			Close()

func Close():
	if !dead && !closed:
		closed = true
		self.get_parent().get_node("Col").disabled = false
		SoundPlayer.stream = OpenSoundEffect
		SoundPlayer.play()
		animTrigger("close")


func animTrigger(triggername : String):
	AnimTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	AnimTree["parameters/conditions/" + triggername] = false;

func animSet(triggername : String):
	AnimTree["parameters/conditions/" + triggername] = true;
