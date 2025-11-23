extends AudioStreamPlayer

@export var main_menu_music : AudioStreamWAV
@export var light_side_music : AudioStreamWAV
@export var dark_side_music : AudioStreamWAV
	
func switch_music(type: String, from_start:bool = false) -> void:
	var playback_position = get_playback_position()

	if type == "light":
		stream = light_side_music
	elif type == "dark":
		stream = dark_side_music
	elif type == "main":
		stream = main_menu_music
		
	if from_start:
		playback_position = 0.0
	play(playback_position)
	print(playback_position)
