extends Area3D
@export var speed : float = 5
@export var lifeTime : float = 5
var PlayerHealth

func _ready():
	PlayerHealth = get_tree().get_first_node_in_group("PlayerHealthHandler")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis.z * delta * speed
	lifeTime -= delta
	if lifeTime < 0:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("PlayerArea"):
		if PlayerHealth != null:
			PlayerHealth.changeHealth(-2)
		else:
			print("collison detected, but PlayerHealth was not found!")

	elif area.is_in_group("NPCArea"):
		get_parent().get_node("HealthController").Hurt(2,false)


func _on_body_entered(body):
	if body.is_in_group("PlayerBody"):
		if PlayerHealth != null:
			PlayerHealth.changeHealth(-2)
		else:
			print("collison detected, but PlayerHealth was not found!")

	elif body.is_in_group("NPCBody"):
		get_parent().get_node("HealthController").Hurt(2,false)
