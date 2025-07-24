extends Node
@onready var PlayerObject = get_parent()
var FlashlightButton : TextureButton
var PlayerHealth : Node2D
var MouseCast

var PlayerSceneRules

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerSceneRules = get_tree().get_first_node_in_group("PlayerSceneRules")
	FlashlightButton = %FlashLightButton
	PlayerHealth = %HealthHandler
	MouseCast = get_parent().get_node("MouseCaster")
	if PlayerSceneRules != null:
		CheckGlobals()


func CheckGlobals():
	if !PlayerSceneRules.FlashlightOn:
		FlashlightButton.ToggleLight(false)
	if !PlayerSceneRules.FlashlightEnabled:
		FlashlightButton.hide()

	PlayerHealth.health = PlayerSceneRules.Health
	PlayerHealth.MaxHealth = PlayerSceneRules.Health
	PlayerHealth.mana = PlayerSceneRules.Stamina
	PlayerHealth.MaxMana = PlayerSceneRules.Stamina
	PlayerHealth.TakeDamage = PlayerSceneRules.TakeDamage
	MouseCast.AttackDelay = PlayerSceneRules.AttackDelay
