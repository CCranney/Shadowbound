extends Node3D

@onready var mirror_mesh : MeshInstance3D = $Mirror
@onready var mirror_world_viewport : SubViewport = $MirrorWorldViewport

var mat : ShaderMaterial

func _ready():
	mirror_world_viewport.size = get_viewport().size
	mat = mirror_mesh.get_active_material(0) as ShaderMaterial
	mat.set_shader_parameter("mirror_world_camera_texture", mirror_world_viewport.get_texture())
