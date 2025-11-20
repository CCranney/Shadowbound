extends RigidBody3D

@onready var navigation_agent_3d : NavigationAgent3D = $NavigationAgent3D

@export var speed := 3.0

func _ready() -> void:
	rotate_y(randf() * PI)

func _physics_process(_delta: float) -> void:
	if not NavigationServer3D.map_is_active(get_world_3d().navigation_map): return

	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	linear_velocity = direction * speed
	if direction.length() > 0.001:
		var flat_direction = Vector3(direction.x, 0, direction.z).normalized()
		look_at(global_position + flat_direction, Vector3.UP)
