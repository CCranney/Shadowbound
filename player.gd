extends CharacterBody3D


const SPEED = 20.0

@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var horizontal_pivot : Node3D = $HorizontalPivot
@onready var vertical_pivot : Node3D = $HorizontalPivot/VerticalPivot
@onready var basket_mesh : MeshInstance3D = $BasketMesh
@onready var diamond_mesh : MeshInstance3D = $DiamondMesh

@export var mouse_sensitivity := 0.00075
@export var vertical_min_boundary: float = -60
@export var vertical_max_boundary: float = 10

var _looking_direction := Vector2.ZERO
enum PlayerHolding {
	NOTHING,
	BASKET,
	DIAMOND,
}
var player_holding_status = PlayerHolding.NOTHING:
	set(new_value):
		player_holding_status = new_value
		if new_value == PlayerHolding.BASKET:
			basket_mesh.visible = true
			diamond_mesh.visible = false
		elif new_value == PlayerHolding.DIAMOND:
			basket_mesh.visible = false
			diamond_mesh.visible = true
		else:
			basket_mesh.visible = false
			diamond_mesh.visible = false

func _ready() -> void:
	basket_mesh.visible = false
	diamond_mesh.visible = false

func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (horizontal_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if direction != Vector3.ZERO:
		var space_state = get_world_3d().direct_space_state

		var query := PhysicsRayQueryParameters3D.new()
		query.from = global_position - Vector3(0,0.5,0)
		query.to = global_position + direction * 1.0
		query.exclude = [self.get_rid()]
		query.collision_mask = collision_mask

		var result = space_state.intersect_ray(query)

		if result and result.collider is RigidBody3D:
			var rb : RigidBody3D = result.collider
			rb.apply_force(direction * 1.0)
	
func frame_camera_rotation() -> void:
	horizontal_pivot.rotate_y(_looking_direction.x)
	vertical_pivot.rotate_x(_looking_direction.y)
	
	vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x, deg_to_rad(vertical_min_boundary),deg_to_rad(vertical_max_boundary) )
	
	spring_arm.global_transform = vertical_pivot.global_transform
	_looking_direction = Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_looking_direction += -event.relative * mouse_sensitivity
