extends TextureButton
@export var viewPos1 : Node3D
@export var viewPos2 : Node3D
var thirdActive : bool
var mainCamera : Camera3D
var unlocked : bool
@export var cameraParent : SpringArm3D
@export var uiElements : Node2D
@export var uiElements2 : Node2D
@export var uiHammer : Node2D
@export_category("HeatShader")
var HeatPlane : MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready():
	HeatPlane = get_tree().get_first_node_in_group("HeatDistort")
	mainCamera = get_viewport().get_camera_3d()
	if thirdActive:
		SetThird()


func ViewCheck():
	if HeatPlane == null:
		HeatPlane = get_tree().get_first_node_in_group("HeatDistort")
	if thirdActive:
		setFirst()
	else:
		SetThird()

func SetThird():
	cameraParent.spring_length = 0.9
	thirdActive = true
	uiElements.hide()
	uiHammer.hide()
	uiElements2.position = Vector2(uiElements2.position.x + 150,uiElements2.position.y)
	cameraParent.position = viewPos2.position
	if HeatPlane != null:
		HeatPlane.hide()
	mainCamera.set_cull_mask_value(5,true)
	mainCamera.set_cull_mask_value(6,false)


func setFirst():
	cameraParent.spring_length = 0
	thirdActive = false
	uiElements.show()
	uiHammer.show()
	uiElements2.position = Vector2(uiElements2.position.x - 150,uiElements2.position.y)
	cameraParent.position = viewPos1.position
	if HeatPlane != null:
		HeatPlane.show()
	mainCamera.set_cull_mask_value(5,false)
	mainCamera.set_cull_mask_value(6,true)
