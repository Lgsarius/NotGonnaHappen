extends Node2D


@export var spawns: Array[Spawn_info] = []
@export var health_multi = 1
@export var spawn_mult = 1
@onready var player = get_tree().get_first_node_in_group("player")
var player_level = 0
var maps_completed  = 0
var time = 0

func _on_timer_timeout() -> void:
	calc_multi()
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		var enemy_count = i.enemy_num * spawn_mult
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < enemy_count:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.health *= health_multi
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
					
					
func get_random_position():
	#var vpr = get_viewport_rect().size *randf_range(1.1,1.3)
	var x = randi_range(0,1390)
	var y = randi_range(0,840)
	#var top_left = Vector2(player.global_position.x -vpr.x/2,player.global_position.y -vpr.y/2)
	#var top_right = Vector2(player.global_position.x +vpr.x/2,player.global_position.y -vpr.y/2)
	#var bottom_left = Vector2(player.global_position.x -vpr.x/2,player.global_position.y +vpr.y/2)
	#var bottom_right = Vector2(player.global_position.x +vpr.x/2,player.global_position.y +vpr.y/2)
	#
	#var pos_side = ["up","down","right","left"].pick_random()
	#var spawn_pos1 = Vector2.ZERO
	#var spawn_pos2 = Vector2.ZERO
	#
	#match pos_side:
		#"up":
			#spawn_pos1 = top_left
			#spawn_pos2 = top_right
		#"down":
			#spawn_pos1 = bottom_left
			#spawn_pos2 = bottom_right
		#"right":
			#spawn_pos1 = top_right
			#spawn_pos2 = bottom_right
		#"left":
			#spawn_pos1 = top_left
			#spawn_pos2 = bottom_left
			#
	#var x_spawn = randf_range(spawn_pos1.x,spawn_pos2.x)
	#var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x,y)
	

func calc_multi():
	player_level = player.level
	health_multi = 1 +(0.01 * (player_level + maps_completed))
	spawn_mult = 1 +(0.3 * (player_level + maps_completed))
	


func _on_game_map_completed() -> void:
	maps_completed += 1
