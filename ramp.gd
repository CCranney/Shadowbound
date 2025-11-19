extends RigidBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name.contains("Fence"):
		axis_lock_linear_x = true
		axis_lock_linear_z = true
