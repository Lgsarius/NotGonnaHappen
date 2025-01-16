extends Node2D

var score = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	%GameTimer.timeout.connect(_on_game_timer_timeout)

func _process(_delta: float) -> void:
	update_timer_display()

func update_timer_display() -> void:
	var time = %GameTimer.time_left
	var minutes = floor(time / 60)
	var seconds = int(time) % 60
	%TimeLeft.text = "%d:%02d" % [minutes, seconds]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Escape key
		if not %GameOver.visible and not %MapComplete.visible:  # Don't pause if game over or map complete screen is showing
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

# Map Complete Handlers
func _on_game_timer_timeout() -> void:
	get_tree().paused = true
	%MapComplete.visible = true
	%ScoreLabel.text = "Final Score: " + str(score)

func _on_map1_button_pressed() -> void:
	get_tree().paused = false
	# Load Forest map scene - replace with actual path
	get_tree().change_scene_to_file("res://scenes/maps/forest_map.tscn")

func _on_map2_button_pressed() -> void:
	get_tree().paused = false
	# Load Desert map scene - replace with actual path
	get_tree().change_scene_to_file("res://scenes/maps/desert_map.tscn")

func _on_map_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu/Menu.tscn")
