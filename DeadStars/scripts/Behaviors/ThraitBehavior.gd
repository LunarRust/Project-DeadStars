extends Node
@export var AnimPlayer : AnimationPlayer
@export var AnimTree : AnimationTree
@export var DialogueSystem : Node3D



func Talk():
	animTrigger("Talk")

func animTrigger(triggername : String):
	AnimTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	AnimTree["parameters/conditions/" + triggername] = false;
