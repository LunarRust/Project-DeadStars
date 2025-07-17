extends Node3D

@export_category("Parameters")
@export var Innocent = false
@export var HP : int = 9
@export var removeOnDeath : bool = true
@export_category("Assignments")
@export var DialogueSystem : Node3D
@export var SoundSource : AudioStreamPlayer3D
var shake
@export var gibRoot = preload("res://prefabs/blood_splatter.tscn")
@export var gibRoot2 = preload("res://prefabs/blood_splatter2.tscn")
@export var HurtSound : AudioStream = load("res://Sounds/Gore02.ogg") as AudioStream
@export_category("Skins")
@export var Body : MeshInstance3D
@export var Skin0 : StandardMaterial3D
@export var Skin1 : StandardMaterial3D
@export var Skin2 : StandardMaterial3D
@export_category("Skin Change Values")
@export var Skin0Num : int = 7
@export var Skin1Num : int = 4
@export var Skin2Num : int = 2

var gib = PackedScene
var gib2 = PackedScene
signal death
var dead : bool

func _ready():
	shake = get_tree().get_first_node_in_group("CameraShake")
func _process(delta):
	if HP < 1 && !dead:
		Death()
		dead = true




func Hurt(amount : int,doShake : bool = false):
	if DialogueSystem != null:
		DialogueSystem.CloseDialogue()
	if HP > 1:
		var node : Node = gibRoot2.instantiate()
		#var node = gib2.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		get_node("/root").add_child(node)
		node.global_position = self.global_position
		SoundSource.stream = HurtSound
		SoundSource.play()
	print("Hurt for " + str(amount))
	HP -= amount
	print(HP)
	if doShake == true:
		shake.Shake(0.08)
	SkinCheck()

###################################
###Change NPC's material based on Health
###################################
func SkinCheck():
	if Body != null:
		if HP > Skin0Num:
			if Body != null:
				Skin0 = Skin0.duplicate()
				Body.set_surface_override_material(0,Skin0)
		elif HP > Skin1Num:
			if Body != null:
				Skin1 = Skin1.duplicate()
				Body.set_surface_override_material(0,Skin1)
		elif HP > Skin2Num:
			if Body != null:
				Skin2 = Skin2.duplicate()
				Body.set_surface_override_material(0,Skin2)

func Death():
	death.emit()
	var node : Node = gibRoot.instantiate()
	if DialogueSystem != null:
		DialogueSystem.CloseDialogue()
	get_node("/root").add_child(node)
	node.global_position = self.global_position
	if removeOnDeath:
		get_parent().queue_free()
	else:
		get_parent().animTrigger("Death")
		get_parent().running = false
