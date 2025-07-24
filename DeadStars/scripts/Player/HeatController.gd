extends MeshInstance3D
var ShaderParameter
@export var MaxAlpha : float = 0.03
var alpha : float = 0
@export var Inc : bool = false
@export var Dec : bool = false

func _ready():
	ShaderParameter = self.get_surface_override_material(0)


func _process(delta):
	if Inc:
		Activate(delta)
	else:
		Deactivate(delta)
	if alpha < 0:
		self.hide()
	else:
		self.show()

func Activate(delta : float):
	if ShaderParameter.get_shader_parameter("distortion") <= MaxAlpha:
		alpha += delta
		ShaderParameter.set_shader_parameter("distortion",alpha)


func  Deactivate(delta : float):
	if ShaderParameter.get_shader_parameter("distortion") > 0:
		alpha -= delta
		ShaderParameter.set_shader_parameter("distortion",alpha)



func Increase():
	Inc = true

func Decrease():
	Inc = false
