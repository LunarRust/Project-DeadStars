extends Node3D
@export var playerObject : Node3D
var playerPosition : Vector3
@export var aggroRange : int = 5
@export var aggro : bool
var timer : float
@export var shotPoint : Node3D
@export var projectileObject : PackedScene
@export var projectileInterval : int
@export var animTree : AnimationTree
@export var soundSource : AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	if playerObject == null:
		playerObject = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.distance_to(playerObject.global_position) < aggroRange:
		aggro = true
	else:
		aggro = false

	if aggro:
		playerPosition = Vector3(playerObject.global_position.x,global_position.y,playerObject.global_position.z)
		look_at(playerPosition,Vector3.UP,true)
		timer += delta
		if timer > projectileInterval:
			ShootTest()
			timer = 0


func Shoot():
	soundSource.play()
	animTrigger("Attack")
	print(self.name + " is shooting.")
	var instance : Node3D = projectileObject.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	get_node("/root").add_child(instance,true,Node.INTERNAL_MODE_DISABLED)
	instance.global_position = shotPoint.global_position
	instance.global_rotation = shotPoint.global_rotation
	await get_tree().create_timer(0.2).timeout


func ShootTest():
	var directSpaceState : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var parameters : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(shotPoint.global_position,playerObject.global_position)
	var dictionary : Dictionary = directSpaceState.intersect_ray(parameters)
	if dictionary.size() > 0 && (dictionary["collider"] as CollisionObject3D).name == "PlayerBody":
		print("player was seen. firing projectile.")
		Shoot()




func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;
