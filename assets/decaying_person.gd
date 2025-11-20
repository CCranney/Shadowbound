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

var seconds_per_body_part: float
var next_unfreeze_time : float

func _ready() -> void:
	for body_part in body_parts_list:
		body_part.freeze = true
	

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
		
func _detach_rigidbody(rb: RigidBody3D) -> void:
	var rb_global_transform = rb.global_transform
	var scene = get_tree().current_scene
	remove_child(rb)
	scene.add_child(rb)
	rb.global_transform = rb_global_transform
	
