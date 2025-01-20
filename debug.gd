extends CanvasLayer



var enemy_count = 0
var loot_count = 0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var Enemy_spawner = get_tree().get_first_node_in_group("enemyspawner")
@onready var label = $Panel/Label

func _on_debug_timer_timeout() -> void:
	
	
	enemy_count = 0
	loot_count = 0
	for child in Enemy_spawner.get_children():
		if "enemy" in child.get_groups() :
			enemy_count += 1
		elif "loot" in child.get_groups():
			loot_count += 1
			
		
			
			
	label.text = "FPS:" +str(Engine.get_frames_per_second()) +"\n" + \
				"player_health: " + str(player.health) + "\n" + \
				"player_level: " + str(player.level) + "\n" + \
				"player_armor: " + str(player.armor) + "\n" + \
				"player_spell_cooldown: " + str(player.spell_cooldown) + "\n" + \
				"player_spell_size: " + str(player.spell_size) + "\n" + \
				"player_add_attacks: " + str(player.additional_attacks) + "\n" + \
				
				"health_mult: " +str(Enemy_spawner.health_multi) + "\n"  +\
				"spawn_multi: " +str(Enemy_spawner.spawn_multi) + "\n"  +\
				"damage_multi: " +str(Enemy_spawner.damage_multi) + "\n"  +\
				"enemy_count: " +str(enemy_count) + "\n"  +\
				"loot_count: " +str(loot_count)
