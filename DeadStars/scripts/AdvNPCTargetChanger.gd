extends Node
@export var TargetNPC : CharacterBody3D
@export var TargetGroup : String

func ReTarget():
	if TargetNPC != null:
		TargetNPC.TargetEntity = TargetNPC.TargetLocator(TargetGroup)
		TargetNPC.attacking = true
