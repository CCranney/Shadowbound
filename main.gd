extends Node3D

@onready var mirror_mesh : MeshInstance3D = $Mirror
@onready var mirror_world_viewport : SubViewport = $MirrorWorldViewport
@onready var current_environment: WorldEnvironment = $CurrentEnvironment
@onready var day_environment: Environment = load("res://environments/day_environment.tres")
@onready var night_environment: Environment = load("res://environments/night_environment.tres")
@onready var main_camera: Camera3D = $Player/SpringArm3D/RemoteTransform3D/Camera3D
@onready var mirror_camera: Camera3D = $MirrorWorldViewport/Camera3D
@onready var mirror_plane: MeshInstance3D = $Mirror
@onready var backup_mirror_plane: MeshInstance3D = $BackupMirrorForHalfwayThrough
@onready var sheep_target: StaticBody3D = $AppleTrees/TargetAppleTree

var mat : ShaderMaterial
var sun_directional_light_mask_bit = 3
var moon_directional_light_mask_bit = 4

func _ready():	
	current_environment.environment = day_environment
	mirror_world_viewport.size = get_viewport().size
	mat = mirror_mesh.get_active_material(0) as ShaderMaterial
	mat.set_shader_parameter("mirror_world_camera_texture", mirror_world_viewport.get_texture())
	
	var all_nodes = _get_all_children(self)
	
	for node in all_nodes:
		if node.is_in_group("mirrorable_object"):
			var mirrored_node := ImmovableMirrorCounterpart.new(node)
			add_child(mirrored_node)
		if node is NavigationAgent3D:
			node.target_position = sheep_target.global_position

	
func _process(_delta):
	if main_camera.global_position.z <= 0:
		mirror_plane.rotation.y = PI
		backup_mirror_plane.rotation.y = PI
		backup_mirror_plane.position.z = 0.5
		current_environment.environment = day_environment
		main_camera.set_cull_mask_value(sun_directional_light_mask_bit, true) 
		main_camera.set_cull_mask_value(moon_directional_light_mask_bit, false) 

		mirror_camera.environment = night_environment
		mirror_camera.set_cull_mask_value(sun_directional_light_mask_bit, false) 
		mirror_camera.set_cull_mask_value(moon_directional_light_mask_bit, true) 
	else:
		mirror_plane.rotation.y = 0
		backup_mirror_plane.rotation.y = 0
		backup_mirror_plane.position.z = -0.5
		current_environment.environment = night_environment
		main_camera.set_cull_mask_value(sun_directional_light_mask_bit, false) 
		main_camera.set_cull_mask_value(moon_directional_light_mask_bit, true) 
		
		mirror_camera.environment = day_environment
		mirror_camera.set_cull_mask_value(sun_directional_light_mask_bit, true) 
		mirror_camera.set_cull_mask_value(moon_directional_light_mask_bit, false) 

func _get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		nodes.append(N)
		if N.get_child_count() > 0:
			nodes.append_array(_get_all_children(N))
	return nodes
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	
