extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial values
	$VBoxContainer/FullscreenToggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_master_volume_changed(value: float) -> void:
	# Implement master volume control
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))

func _on_music_volume_changed(value: float) -> void:
	# Implement music volume control
	if AudioServer.get_bus_index("Music") >= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))

func _on_sfx_volume_changed(value: float) -> void:
	# Implement SFX volume control
	if AudioServer.get_bus_index("SFX") >= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))

func _on_fullscreen_toggle(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_button_pressed() -> void:
	# Return to main menu
	get_tree().change_scene_to_file("res://scenes/MainMenu/menu.tscn") 
