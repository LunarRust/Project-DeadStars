extends AnimationPlayer
@export var Anim : String = "Open"

func _ready():
	self.stop()
	self.active = false


func Anim_Play():
	self.active = true
	self.play("Open")
