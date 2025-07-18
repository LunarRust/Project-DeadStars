extends AudioStreamPlayer3D
@export var ptichRange : Vector2 = Vector2(0.8,1.2)

func _ready():
	self.pitch_scale = randf_range(0.8,1.2)
	self.play()
