extends Node2D

var score = 0
var time_remaining = 10
var time_remaining_init = 10
var current_xp = 0
var target_xp = 0
var xp_tween: Tween
var map_xp_collected = 0

@onready var player = $Player
@onready var map1_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map1")
@onready var map2_btn = %MapComplete.get_node("ColorRect/HBoxContainer/Map2")
var map_options = ["nix","nix"]
 
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	update_countdown_display()
	load_selected_map(get_random_map_options()[0])
	player.experience_updated.connect(_on_player_experience_updated)

func _on_player_experience_updated(_current_exp: int, collected_exp: int, _exp_cap: int) -> void:
	map_xp_collected += collected_exp
	print("XP Updated - Map XP collected: ", map_xp_collected)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		if not %GameOver.visible and not %MapComplete.visible:  
			toggle_pause()
			$PauseMenu/VBoxContainer/ResumeButton.grab_focus()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	%PauseMenu.visible = get_tree().paused

func spawn_mob():
	var path_follow = find_child("PathFollow2D", true, false)
	if not path_follow:
		return
		
	var new_mob = preload("res://mob.tscn").instantiate()
	path_follow.progress_ratio = randf()
	new_mob.global_position = path_follow.global_position
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
	get_tree().paused = true
	
	%MapComplete.visible = true
	%MapComplete.process_mode = Node.PROCESS_MODE_ALWAYS
	map1_btn.visible = true
	map2_btn.visible = true
	map1_btn.grab_focus()
	%ExperienceBar.visible = false
	%Countdown.visible = false
	%Score.visible = false
	
	current_xp = 0
	target_xp = map_xp_collected
	%XPProgress.max_value = player.calculate_experiencecap()
	%XPProgress.value = 0
	update_xp_label(0)
	
	if xp_tween:
		xp_tween.kill()
	xp_tween = create_tween()
	xp_tween.tween_property(self, "current_xp", target_xp, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	map_options = get_random_map_options()
	
	if is_instance_valid(map1_btn):
		map1_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map2_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		
		map1_btn.text = get_map_display_name(map_options[0])
		map2_btn.text = get_map_display_name(map_options[1])
		
		map1_btn.set_meta("map_path", map_options[0])
		map2_btn.set_meta("map_path", map_options[1])

func _process(_delta: float) -> void:
	if %MapComplete.visible and current_xp != %XPProgress.value:
		%XPProgress.value = current_xp
		update_xp_label(current_xp)

func update_xp_label(current: float) -> void:
	%XPLabel.text = str(round(current)) + "/" + str(%XPProgress.max_value) + " XP"

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
	map_xp_collected = 0
	get_tree().paused = false
	%MapComplete.visible = false
	
	%ExperienceBar.visible = true
	%Countdown.visible = true
	%Score.visible = true
	
	time_remaining = time_remaining_init
	update_countdown_display()
	
	cleanup_map()
	
	var selected_map = load(map_path).instantiate()
	add_child(selected_map)

func cleanup_map():
	for child in get_children():
		if "map" in child.get_groups() or "enemy" in child.get_groups() or "loot" in child.get_groups():
			remove_child(child)
			child.queue_free()
	player.global_position = $Spawnpoint.global_position
			
func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	$GameOver/ColorRect/VBoxContainer/RestartButton.grab_focus()
	get_tree().paused = true

func _on_mob_mob_death() -> void:
	pass

func _on_player_loot_collected() -> void:
	score += 1
	%Score.text = str(score)

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

func _on_map_1_pressed() -> void:
	load_selected_map(map_options[0])

func _on_map_2_pressed() -> void:
	load_selected_map(map_options[1])
