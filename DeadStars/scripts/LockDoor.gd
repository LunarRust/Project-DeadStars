extends Node
@export var itemMatch : String
var opened : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Item(item: String):
	print("Trying Key")
	if item == itemMatch && !opened:
		Open()

func Open():
	if !opened:
		opened = true
		var node = get_node("%SoundSource")
		node.stream = load("res://Sounds/DoorBig.ogg") as AudioStream
		node.play()
		var tween : Tween = create_tween().set_parallel()
		tween.tween_property(get_parent(),"position",Vector3.UP * 4,2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()
		await get_tree().create_timer(2.0).timeout
		Destroy()

func Destroy():
	get_parent().queue_free()
