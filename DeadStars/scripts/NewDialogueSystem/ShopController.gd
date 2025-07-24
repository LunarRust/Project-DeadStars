extends Node2D
@export var PlayerDisplay : CtrlInventoryGridEx
var PlayerInv : Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if PlayerInv != null:
		PlayerDisplay.inventory_path = PlayerInv.get_path()
