extends Control

@onready var intro_text : Control = $IntroText
@onready var main_menu : Control = $MainMenu
@onready var timer_info : Control = $TimerInfo
@onready var timer_label : Label = %TimerLabel
@onready var timer : Timer = $Timer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	main_menu.visible = false
	timer_info.visible = false
	timer_label.text = str(timer.time_left)
	
func _process(_delta: float) -> void:
	timer_label.text = format_time(timer.time_left)

func format_time(t: float) -> String:
	@warning_ignore("integer_division")
	var minutes = int(t) / 60
	var seconds = int(t) % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_continue_button_pressed() -> void:
	intro_text.visible = false
	main_menu.visible = true

func _on_infinite_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.visible = false
	timer_info.visible = false

func _on_easy_button_pressed() -> void:
	timer.wait_time = 5 * 60
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.visible = false
	timer_info.visible = true
	timer.start()

func _on_medium_button_pressed() -> void:
	timer.wait_time = 3 * 60
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.visible = false
	timer_info.visible = true
	timer.start()

func _on_hard_button_pressed() -> void:
	timer.wait_time = 60
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.visible = false
	timer_info.visible = true
	timer.start()
