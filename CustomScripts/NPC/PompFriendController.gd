extends Node
@export var soundsource : AudioStreamPlayer
@export var Sound : AudioStream
@export var FriendUIParent : Node2D
signal AttackEnimeies
signal FollowPlayer
var NPCsettings

func _ready():
	NPCsettings = get_tree().get_first_node_in_group("NpcSceneRules")
	if  NPCsettings != null:
		if NPCsettings.AllowPlayerControl == false:
			if FriendUIParent != null:
				FriendUIParent.hide()
			else:
				pass

func _on_attack_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Activate_Pomp_Target")
	DoOnAllPress()

func _on_player_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Activate_Player_Target")
	DoOnAllPress()

func _on_kill_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Kill_pomp")
	DoOnAllPress()

func _on_item_grab_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Item_Grab")
	DoOnAllPress()

func _on_flash_light_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Light_Toggle")
	DoOnAllPress()

func DoOnAllPress():
	soundsource.stream = Sound
	soundsource.play()
