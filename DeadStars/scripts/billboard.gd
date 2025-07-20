@tool
extends MeshInstance3D
@export var Billboard : bool = false


# Called when the node enters the scene tree for the first time.
func rotate_area_to_billboard():
	var billboard_mode = self.get_surface_override_material(0).billboard_mode

	# Try to match the area with the material's billboard setting, if enabled.
	if billboard_mode > 0:
		# Get the camera.
		var camera = get_viewport().get_camera_3d()
		# Look in the same direction as the camera.
		if camera != null:
			var look = camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
			look = self.position + look

			# Y-Billboard: Lock Y rotation, but gives bad results if the camera is tilted.
			if billboard_mode == 2:
				look = Vector3(look.x, 0, look.z)

			self.look_at(look, Vector3.UP)

			# Rotate in the Z axis to compensate camera tilt.
			self.rotate_object_local(Vector3.BACK, camera.rotation.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
