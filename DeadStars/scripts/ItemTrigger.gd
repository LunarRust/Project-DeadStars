extends Node
@export var itemMatch : String
@export var ItemToGive : String = "default"
@export var OneUse : bool = false
signal ItemSuccess
signal ItemFailure
var used : bool = false
var inv

func _ready():
	inv = get_tree().get_first_node_in_group("PlayerInv")

func Item(item : String):
	if used == false:
		print("trying item")
		if item == itemMatch:
			if ItemToGive != "default":
				var newItem = inv.create_and_add_item(ItemToGive)
			print("Item Valid!")
			ItemSuccess.emit()
			if OneUse == true:
				self.get_parent().queue_free()
		else:
			ItemFailure.emit()
			print("Item invalid ):")
