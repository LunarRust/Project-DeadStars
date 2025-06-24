extends Node
@export var BehaviorNode : Node

func Interact(mode : int):
	if mode == 1:
		print("Calling 'look' method.")
		if BehaviorNode != null && BehaviorNode.has_method("Look"):
			BehaviorNode.call("Look")

	if mode == 2 && BehaviorNode != null && BehaviorNode.has_method("Talk"):
		BehaviorNode.call("Talk")

	if mode == 3 && BehaviorNode != null && BehaviorNode.has_method("Touch"):
		BehaviorNode.call("Touch")
