extends Node
@export var DialogueSystem : Node3D
@export var Animationplayer : AnimationPlayer
@export var animTree : AnimationTree

func Talk():
	animTrigger("Talk")

func Hurt():
	DialogueSystem.CloseDialogue()



func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;
