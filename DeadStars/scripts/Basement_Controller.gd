extends Node
var Kills : int = 0
var used : bool = false
var playerCam : Camera3D
@export var otherCam : Camera3D
@export var HudManager : CanvasLayer

signal DoorActivate
# Called when the node enters the scene tree for the first time.
func _ready():
	playerCam = get_tree().get_first_node_in_group("PlayerCamera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_physical_key_pressed(KEY_F5)):
		HeartKills()



func HeartKills():
	Kills += 1

	if Kills >= 2:
		await get_tree().create_timer(4.0).timeout
		HudManager.HideHUD()
		otherCam.make_current()
		await get_tree().create_timer(1.0).timeout
		DoorActivate.emit()
		await get_tree().create_timer(3.0).timeout
		HudManager.ShowHUD()
		playerCam.make_current()
