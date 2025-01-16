extends Node2D

var score = 0
signal game_completed

var time_remaining = 10  # 2 minutes in seconds
var time_remaining_init = 10 
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	update_countdown_display()

	open_random_map()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Escape key
		if not %GameOver.visible and not %MapComplete.visible:  # Don't pause if end screens showing
			toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	%PauseMenu.visible = get_tree().paused

func spawn_mob():
	var path_follow = find_child("PathFollow2D", true, false)
	if not path_follow:
		print("Warning: PathFollow2D not found in the current map")
		return
		
	var new_mob = preload("res://mob.tscn").instantiate()
	path_follow.progress_ratio = randf()
	new_mob.global_position = path_follow.global_position
	new_mob.mob_death.connect(_on_mob_mob_death.bind())
	add_child(new_mob)

func open_random_map():
	var maps = [
		"res://maps/Prod_Maps/wood_map.tscn",
		"res://maps/Prod_Maps/cozy_diner_map.tscn",
		"res://maps/Prod_Maps/desert_map.tscn"
	]
	var random_map_path = maps[randi() % maps.size()]
	var selected_map = load(random_map_path).instantiate()
	add_child(selected_map)

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
	print(has_node("%MapComplete"))
	print(get_node_or_null("%MapComplete")) 
	get_tree().paused = true
	%MapComplete.visible = true
	%MapComplete.process_mode = Node.PROCESS_MODE_ALWAYS
	%ExperienceBar.visible = false
	%Countdown.visible = false
	%Score.visible = false
	emit_signal("game_completed")
	var map_options = get_random_map_options()
	var map1_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map1")
	var map2_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map2")
	if is_instance_valid(map1_btn):
		map1_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map2_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map1_btn.text = get_map_display_name(map_options[0])
		map2_btn.text = get_map_display_name(map_options[1])
		map1_btn.set_meta("map_path", map_options[0])
		map2_btn.set_meta("map_path", map_options[1])
		
		map1_btn.gui_input.connect(func(event): 
			if event is InputEventMouseButton and event.pressed:
				load_selected_map(map_options[0]))
		map2_btn.gui_input.connect(func(event): 
			if event is InputEventMouseButton and event.pressed:
				load_selected_map(map_options[1]))

func get_map_display_name(map_path: String) -> String:
	var file_name = map_path.get_file().trim_suffix(".tscn")
	var words = file_name.split("_")
	var formatted_name = ""
	for word in words:
		formatted_name += word.capitalize() + " "
	return formatted_name.strip_edges()

func get_random_map_options() -> Array:
	var maps = [
		"res://maps/Prod_Maps/wood_map.tscn",
		"res://maps/Prod_Maps/cozy_diner_map.tscn",
		"res://maps/Prod_Maps/desert_map.tscn"
	]
	maps.shuffle()
	return maps.slice(0, 2)



func load_selected_map(map_path: String) -> void:
	print("Starting map load: ", map_path)
	get_tree().paused = false
	%MapComplete.visible = false
	%ExperienceBar.visible = true
	%Countdown.visible = true
	%Score.visible = true
	
	time_remaining = time_remaining_init
	update_countdown_display()

	print("Current children before cleanup: ", get_children())
	for child in get_children():
		print("Checking child: ", child.name)
		if "map" in child.name.to_lower():
			print("Removing map node: ", child.name)
			remove_child(child)
			child.queue_free()
	
	await get_tree().process_frame
	
	print("Loading new map: ", map_path)
	var selected_map = load(map_path).instantiate()
	add_child(selected_map)

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_mob_mob_death() -> void:
	pass
	

func _on_player_loot_collected() -> void:
	score += 1
	%Score.text = str(score)
	print(score)

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
	
