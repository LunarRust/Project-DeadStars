extends TextureButton
@export var parent : CharacterBody3D
@export var Inv : Inventory
@export var SoundSource : AudioStreamPlayer3D
@export var SoundEffect : AudioStream
var PlayerInv : Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInv = get_tree().get_first_node_in_group("PlayerInv")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.TargetReached == false:
		self.hide()
	else:
		self.show()


func _on_pressed():
	if !Inv.get_item_count() == 0:
		var InvList
		InvList = Inv.get_items()

		for i in InvList:
			PlayerInv.create_and_add_item(i.prototype_id)
		SoundSource.stream = SoundEffect
		SoundSource.play()
		Inv.clear()
