extends RigidBody3D


@onready var navigation_agent_3d : NavigationAgent3D = $NavigationAgent3D
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var sheep_noises : Array[AudioStreamWAV]
@export var speed := 3.0

var is_moving: bool:
	set(new_value):
		is_moving = new_value
		if new_value:
			audio_stream_player_3d.play()
		else:
			audio_stream_player_3d.stop()
		
var bleeting_frequency_in_seconds := 10
			
			
func _ready() -> void:
	rotate_y(randf() * PI)
	audio_stream_player_3d.visible = false

func _process(delta: float) -> void:
	if randf() < delta / bleeting_frequency_in_seconds and is_moving:
		audio_stream_player_3d.stream = sheep_noises[randi() % sheep_noises.size()]
		audio_stream_player_3d.play()

func _physics_process(_delta: float) -> void:
	var check_is_moving = (linear_velocity != Vector3.ZERO and not freeze)
	if check_is_moving and not is_moving:
		is_moving = true
	elif not check_is_moving and is_moving:
		is_moving = false
		
	if not NavigationServer3D.map_is_active(get_world_3d().navigation_map): 
		bleeting_frequency_in_seconds = 10
		return
	bleeting_frequency_in_seconds = 30
	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	linear_velocity = direction * speed
	var flat_direction = Vector3(direction.x, 0, direction.z).normalized()
	if flat_direction.length() > 0.001:
		look_at(global_position + flat_direction, Vector3.UP)

func _on_wait_to_bleet_timer_timeout() -> void:
	audio_stream_player_3d.visible = true
