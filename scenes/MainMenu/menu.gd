extends Control

@onready var path_follow: PathFollow2D = $ColorRect/Path2D/PathFollow2D

@export var speed = 100

func _ready() -> void:
	$VBoxContainer/StartButton2.grab_focus()
	pass

func _process(_delta: float) -> void:
	path_follow.progress += speed * _delta

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Character Selection/CharacterSelection.tscn")
	print("Start Pressed")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")
	print("Settings Pressed")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	print("Exit Pressed")
