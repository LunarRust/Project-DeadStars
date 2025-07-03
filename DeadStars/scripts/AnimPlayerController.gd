extends AnimationPlayer


func _ready():
	self.stop()
	self.active = false


func Anim_Play():
	self.active = true
	self.play("Open")
