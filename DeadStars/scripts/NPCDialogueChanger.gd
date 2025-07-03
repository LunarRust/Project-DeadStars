extends Node
@export var NPC : Node3D
@export_multiline var NewDialogue : Array[String]
@export_multiline var NewLook : Array[String]
@export_multiline var NewTouch : Array[String]

var NPCDialogue


func _ready():
	NPCDialogue = NPC.get_node("DialogueSystem")

func ChangeDialogue():

	if !NewDialogue.is_empty():
		NPCDialogue.Dialogue = NewDialogue
	if !NewLook.is_empty():
		NPCDialogue.LookDescription = NewLook
	if !NewTouch.is_empty():
		NPCDialogue.TouchDescription = NewTouch
