extends Node
@export var AnimPlayer : AnimationPlayer

func _ready():
	AnimPlayer.active = false

func Play():
	AnimPlayer.play("Light")
	AnimPlayer.active = true
	AnimPlayer.play("Light")
