extends Node2D

var score = 0

var time_remaining =100
var time_remaining_init = 100
var mob_death_count = 0

@onready var player = $Player
@onready var map1_btn = %MapComplete.get_node("ColorRect/Map1")
@onready var map2_btn = %MapComplete.get_node("ColorRect/Map2/")

signal map_completed
signal Game_time(minutes,seconds)
var map_options = ["nix","nix"]
 
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	update_countdown_display()
	load_selected_map(get_random_map_options()[0])
	player.toggle_character_info(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		if not %GameOver.visible and not %MapComplete.visible:  
			toggle_pause()
			$PauseMenu/HBoxContainer/VBoxContainer/ResumeButton.grab_focus()
	if event.is_action_pressed("debug"):
		if not $DebugWindow.visible:
			$DebugWindow.visible  = true
			$DebugWindow.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			$DebugWindow.visible = false
	
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	player.toggle_character_info(false)
	%PauseMenu.visible = get_tree().paused

func _on_timer_4_countdown_timeout() -> void:
	time_remaining -= 1
	if time_remaining <= 0:
		show_map_complete()
	else:
		update_countdown_display()

func update_countdown_display() -> void:
	var minutes = floor(time_remaining / 60)
	var seconds = time_remaining % 60
	Game_time.emit(minutes,seconds)

func show_map_complete() -> void:
	map_completed.emit()
	print("Showing map complete screen")
	get_tree().paused = true
	
	%MapComplete.visible = true
	%MapComplete.process_mode = Node.PROCESS_MODE_ALWAYS
	map1_btn.visible = true
	map2_btn.visible = true
	map1_btn.grab_focus()
	
	
	player.toggle_character_info(false)
	
	
	%MapComplete.get_node("ColorRect/MobDeathCount").text = "Killed Enemies: " + str(mob_death_count)
	
	map_options = get_random_map_options()
	
	if is_instance_valid(map1_btn):
		map1_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		map2_btn.process_mode = Node.PROCESS_MODE_ALWAYS
		
		map1_btn.get_node("Map1Label").text = get_map_display_name(map_options[0])
		map2_btn.get_node("Map2Label").text = get_map_display_name(map_options[1])
		
		map1_btn.set_meta("map_path", map_options[0])
		map2_btn.set_meta("map_path", map_options[1])
		



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
		"res://maps/Prod_Maps/winter_map.tscn"
	]
	
	maps.shuffle()
	
	return maps.slice(0, 2)



func load_selected_map(map_path: String) -> void:
	print("Starting map load: ", map_path)
	get_tree().paused = false
	%MapComplete.visible = false
	
	
	player.toggle_character_info(true)

	
	mob_death_count = 0
	time_remaining = time_remaining_init
	update_countdown_display()
	
	cleanup_map()
	
	
	
	print("Loading new map: ", map_path)
	var selected_map = load(map_path).instantiate()
	add_child(selected_map)


func cleanup_map():
	for child in get_children():
		if "map" in child.get_groups() :
			print("Removing node: ", child.name)
			remove_child(child)
			child.queue_free()
	player.global_position = $Spawnpoint.global_position
	player.health = player.maxhealth
	
			
func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	$GameOver/ColorRect/VBoxContainer/RestartButton.grab_focus()
	get_tree().paused = true


func _on_mob_mob_death() -> void:
	mob_death_count += 1


func _on_player_loot_collected() -> void:
	score += 1
	%Score.text = str(score)
	print(score)


func _on_resume_button_pressed() -> void:
	toggle_pause()
	player.toggle_character_info(true)

func _on_settings_button_pressed() -> void:
	var settings_scene = load("res://scenes/Settings/GameSettings.tscn").instantiate()
	settings_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var settings_layer = CanvasLayer.new()
	settings_layer.layer = 3  # Put it above other UI layers
	add_child(settings_layer)
	settings_layer.add_child(settings_scene)
	
	%PauseMenu.visible = false
	settings_scene.get_node("BackButton").pressed.connect(_on_settings_back_pressed.bind(settings_scene, settings_layer))

func _on_settings_back_pressed(_settings_scene: Node, settings_layer: CanvasLayer) -> void:
	settings_layer.queue_free()  # This will also free the settings_scene
	%PauseMenu.visible = true

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

func _upgrade_pressed():
	print("Ich bring mich um")
	
func become_host():
	print("Host Pressed")
	%HostButton.hide()
	MultiplayerManager.become_host()

func join_as_player_2():
	print("Join as Player 2")
	%JoinButton.hide()
	MultiplayerManager.join_as_player_2()
