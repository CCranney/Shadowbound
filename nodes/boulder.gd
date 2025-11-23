extends RigidBody3D

@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D

var is_moving: bool:
	set(new_value):
		is_moving = new_value
		if new_value:
			audio_stream_player_3d.play()
		else:
			audio_stream_player_3d.stop()

func _ready() -> void:
	is_moving = false	

func _physics_process(_delta: float) -> void:
	var check_is_moving = (linear_velocity != Vector3.ZERO and not freeze)
	if check_is_moving and not is_moving:
		is_moving = true
	elif not check_is_moving and is_moving:
		is_moving = false
		
		
