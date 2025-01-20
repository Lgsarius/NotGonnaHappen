extends Node2D


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	print("Start Pressed")
	
func _on_back_button_pressed() -> void:

	get_tree().change_scene_to_file("res://scenes/MainMenu/Menu.tscn")
