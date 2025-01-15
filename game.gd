extends Node2D

var score = 0

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
	score += 1
	%Score.text = str(score)
	print(score)
	
