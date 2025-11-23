extends Node3D

@onready var body_parts_list: Array[RigidBody3D] = [
	$"RightFoot-rigid",
	$"LeftHand-rigid",
	$"RightHand-rigid",
	$"RightKnee-rigid",
	$"LeftFoot-rigid",
	$"LeftKnee-rigid",
	$"Pelvis-rigid",
	$"RightTorso-rigid",
	$"LeftTorso-rigid",
	$"LowerHead-rigid",
	$"UpperHead-rigid",
]
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var break_noises : Array[AudioStreamWAV]

var seconds_per_body_part: float
var next_unfreeze_time : float
var next_break_noise_idx = 0

func _ready() -> void:
	for body_part in body_parts_list:
		body_part.freeze = true
	assert(break_noises.size() > 0, "Requires least one break noise assigned")
	

func _process(_delta: float) -> void:
	if TimerState.wait_time == 0.0: return
	if seconds_per_body_part == 0.0:
		seconds_per_body_part = TimerState.wait_time / len(body_parts_list)
		next_unfreeze_time = TimerState.wait_time - seconds_per_body_part
	if TimerState.time_left < next_unfreeze_time:
		var body_part = body_parts_list[0]
		body_part.freeze = false
		body_parts_list.pop_front()
		_detach_rigidbody(body_part)
		next_unfreeze_time -= seconds_per_body_part
		audio_stream_player_3d.stream = break_noises[next_break_noise_idx]
		audio_stream_player_3d.play()
		next_break_noise_idx = (next_break_noise_idx + 1) % break_noises.size()
		
func _detach_rigidbody(rb: RigidBody3D) -> void:
	var rb_global_transform = rb.global_transform
	var scene = get_tree().current_scene
	remove_child(rb)
	scene.add_child(rb)
	rb.global_transform = rb_global_transform
	
