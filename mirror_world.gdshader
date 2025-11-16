shader_type spatial;

render_mode unshaded;

uniform sampler2D mirror_world_camera_texture: source_color;

void fragment() {	
	vec4 tex = texture(mirror_world_camera_texture, SCREEN_UV);
	ALBEDO = tex.rgb;
}