extends Node2D

var score = 0
signal game_completed

var time_remaining = 10  # 2 minutes in seconds

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	update_countdown_display()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Escape key
		if not %GameOver.visible and not %MapComplete.visible:  # Don't pause if end screens showing
			toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	%PauseMenu.visible = get_tree().paused

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.mob_death.connect(_on_mob_mob_death.bind())
	add_child(new_mob)
	


func _on_timer_timeout() -> void:
	spawn_mob()


func _on_timer_4_countdown_timeout() -> void:
	time_remaining -= 1
	if time_remaining <= 0:
		show_map_complete()
	else:
		update_countdown_display()

func update_countdown_display() -> void:
	var minutes = floor(time_remaining / 60)
	var seconds = time_remaining % 60
	%Countdown.text = "%d:%02d" % [minutes, seconds]

func show_map_complete() -> void:
	print("Showing map complete screen")
	get_tree().paused = true
	%MapComplete.visible = true
	%MapComplete.process_mode = Node.PROCESS_MODE_ALWAYS
	%ExperienceBar.visible = false
	%Countdown.visible = false
	%Score.visible = false
	emit_signal("game_completed")
	print("Map complete screen should be visible now")
	# Add debug print to check if MapComplete node exists and is visible
	print("MapComplete node exists: ", is_instance_valid(%MapComplete))
	print("MapComplete visible: ", %MapComplete.visible)
	# Check if buttons exist and set up monitoring
	var map1_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map1")
	var map2_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map2")
	print("Map1 button exists: ", is_instance_valid(map1_btn))
	print("Map2 button exists: ", is_instance_valid(map2_btn))
	if is_instance_valid(map1_btn):
		print("Map1 button mouse filter: ", map1_btn.mouse_filter)
		print("Map1 button visible: ", map1_btn.visible)
		# Set up input monitoring
		map1_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map2_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map1_btn.gui_input.connect(func(event): print("Map1 received input: ", event))
		map2_btn.gui_input.connect(func(event): print("Map2 received input: ", event))

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_mob_mob_death() -> void:
	pass
	


func _on_player_loot_collected() -> void:
	score += 1
	%Score.text = str(score)
	print(score)

# Pause Menu Button Handlers
func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")

func _on_pause_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_pause_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu/Menu.tscn")


func _on_map1_pressed() -> void:
	print("MAP1 Button was pressed!")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/maps/map1.tscn")
	


func _on_map2_pressed() -> void:
	print("MAP2 Button was pressed!")
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/maps/map2.tscn")
	
