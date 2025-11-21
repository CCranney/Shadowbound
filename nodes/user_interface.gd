extends Control

@onready var background_texture : TextureRect = $TextureRect
@onready var intro_text : Control = $IntroText
@onready var main_menu : Control = $MainMenu
@onready var timer_info : Control = $TimerInfo
@onready var timer_label : Label = %TimerLabel
@onready var timer : Timer = $Timer
@onready var finish_screen : Control = $FinishScreen
@onready var finish_screen_label : Label = %FinishScreenLabel

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	intro_text.visible = false
	timer_info.visible = false
	finish_screen.visible = false
	timer_label.text = str(timer.time_left)
	get_tree().paused = true	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(_delta: float) -> void:
	timer_label.text = format_time(timer.time_left)
	TimerState.time_left = timer.time_left

func format_time(t: float) -> String:
	@warning_ignore("integer_division")
	var minutes = int(t) / 60
	var seconds = int(t) % 60
	var milliseconds = int((t - int(t))*10)
	return "%02d:%02d.%01d" % [minutes, seconds, milliseconds]

func _on_tutorial_button_pressed() -> void:
	main_menu.visible = false
	intro_text.visible = true

func _on_infinite_button_pressed() -> void:
	_set_timer_and_start_game(false)

func _on_easy_button_pressed() -> void:
	timer.wait_time = 5 * 60
	_set_timer_and_start_game()

func _on_medium_button_pressed() -> void:
	timer.wait_time = 2 * 60
	_set_timer_and_start_game()

func _on_hard_button_pressed() -> void:
	timer.wait_time = 60
	_set_timer_and_start_game()
	
func _set_timer_and_start_game(is_timer_on: bool = true):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.visible = false
	get_tree().paused = false
	background_texture.visible = false
	
	if is_timer_on:
		TimerState.wait_time = timer.wait_time
		timer.start()
		TimerState.time_left = timer.time_left
		timer_info.visible = true

func end_game_screen(is_victorious: bool) -> void:
	get_tree().paused = true	
	timer.paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	background_texture.visible = true
	if is_victorious:
		finish_screen.visible = true
		finish_screen_label.text = "Success!"
	else:
		finish_screen.visible = true
		finish_screen_label.text = "Game Over"
		timer_info.visible = false

func _on_timer_timeout() -> void:
	end_game_screen(false)
	
func _on_continue_button_pressed() -> void:
	intro_text.visible = false
	main_menu.visible = true

func _on_main_menu_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
