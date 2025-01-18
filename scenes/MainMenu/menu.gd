extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton2.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	print("Start Pressed")


func _on_multiplayer_button_pressed() -> void:
	print("Multiplayer Pressed")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")
	print("Settings Pressed")


func _on_level_select_button_pressed() -> void:
	print("Level Select Pressed")
	# TODO: Implement level selection scene transition


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	print("Exit Pressed")
