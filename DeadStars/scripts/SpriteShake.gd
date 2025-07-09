extends Node2D
var startPos : Vector2
@export var power : float = 1


func _ready():
	startPos = self.position


func _process(delta):
	self.position = Vector2(startPos.x + randf_range(-1,1) * power,startPos.y + randf_range(-1,1) * power)
