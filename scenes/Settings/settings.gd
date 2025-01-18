extends Control

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

func _ready() -> void:
	# Set initial values for fullscreen
	$VBoxContainer/HBoxContainer/FullscreenToggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	# Load saved settings
	load_settings()
	
	# Set initial slider values from current audio bus volumes
	var master_volume = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
	$VBoxContainer/MasterVolumeContainer/HSlider.value = master_volume
	
	# Only set Music and SFX if the buses exist
	if AudioServer.get_bus_index("Music") >= 0:
		var music_volume = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
		$VBoxContainer/MusicVolumeContainer/HSlider/HSlider.value = music_volume
	
	if AudioServer.get_bus_index("SFX") >= 0:
		var sfx_volume = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100
		$VBoxContainer/SFXVolumeContainer/HSlider.value = sfx_volume

func load_settings() -> void:
	var err = config.load(SAVE_PATH)
	if err != OK:
		return
	
	# Load volumes
	var master_vol = config.get_value("audio", "master", 80.0)
	var music_vol = config.get_value("audio", "music", 80.0)
	var sfx_vol = config.get_value("audio", "sfx", 80.0)
	
	# Apply loaded volumes
	_on_master_volume_changed(master_vol)
	_on_music_volume_changed(music_vol)
	_on_sfx_volume_changed(sfx_vol)
	
	# Load fullscreen setting
	var fullscreen = config.get_value("video", "fullscreen", false)
	$VBoxContainer/HBoxContainer/FullscreenToggle.button_pressed = fullscreen
	_on_fullscreen_toggle(fullscreen)

func save_settings() -> void:
	# Save volumes
	config.set_value("audio", "master", $VBoxContainer/MasterVolumeContainer/HSlider.value)
	config.set_value("audio", "music", $VBoxContainer/MusicVolumeContainer/HSlider.value)
	config.set_value("audio", "sfx", $VBoxContainer/SFXVolumeContainer/HSlider.value)
	
	# Save fullscreen setting
	config.set_value("video", "fullscreen", $VBoxContainer/HBoxContainer/FullscreenToggle.button_pressed)
	
	# Save to file
	config.save(SAVE_PATH)

func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
	save_settings()

func _on_music_volume_changed(value: float) -> void:
	if AudioServer.get_bus_index("Music") >= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))
		save_settings()

func _on_sfx_volume_changed(value: float) -> void:
	if AudioServer.get_bus_index("SFX") >= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))
		save_settings()

func _on_fullscreen_toggle(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func _on_back_button_pressed() -> void:
	# Save settings before going back
	save_settings()
	# Return to main menu
	get_tree().change_scene_to_file("res://scenes/MainMenu/Menu.tscn") 
