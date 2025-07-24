extends Area3D
var NPCParent : CharacterBody3D
var NPCInv : Inventory


# Called when the node enters the scene tree for the first time.
func _ready():
	NPCParent = self.get_parent()
	NPCInv = self.get_parent().get_node("InventoryGrid")

func _on_body_entered(body):
	if body.has_node("HealthController") && !body.is_in_group("PompNPC"):
		NPCParent.TargetEnimies()
	elif body.has_node("Behavior"):
		if body.get_node("Behavior").has_method("Touch") && body.get_node("Behavior").has_method("create_item"):
			NPCParent.LocateItem()
	if body.has_node("Behavior") && !body.is_in_group("PompNPC"):
		var behaviorNode = body.get_node("Behavior")
		if behaviorNode.has_method("Item"):
			if NPCInv.get_item_count() > 0:
				NPCParent.LocateUsable()
