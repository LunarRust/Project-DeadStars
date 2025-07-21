extends Node
@export var animTree : AnimationTree

# Called when the node enters the scene tree for the first time.
func Touch():
	animTrigger("Junior_Attack")




func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;
