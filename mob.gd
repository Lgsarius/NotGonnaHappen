extends CharacterBody2D

signal mob_death
var health = 3
var speed = 300.0
var mob_type = "normal"

func _ready() -> void:
	%Slime.play_walk()
	# Randomly assign mob type and properties
	var types = ["normal", "fast", "tank", "boss"]
	mob_type = types[randi() % types.size()]
	
	match mob_type:
		"normal":
			health = 3
			speed = 300.0
			scale = Vector2(1, 1)
		"fast":
			health = 2
			speed = 450.0
			scale = Vector2(0.8, 0.8)
			modulate = Color(1, 0.5, 0.5)
		"tank":
			health = 5
			speed = 200.0
			scale = Vector2(1.3, 1.3)
			modulate = Color(0.5, 1, 0.5)
		"boss":
			health = 8
			speed = 250.0
			scale = Vector2(1.8, 1.8)
			modulate = Color(1, 0.8, 0.2)
	
	# Find the player using a relative path from the scene root
	var player = get_tree().get_first_node_in_group("player")
	if player:
		look_at(player.global_position)

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

func take_damage() -> void:
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		emit_signal("mob_death")
		drop_loot()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()

func drop_loot() -> void:
	var new_orb = preload("res://orb.tscn").instantiate()
	new_orb.global_position = global_position
	# Drop more orbs for stronger enemies
	match mob_type:
		"normal":
			get_parent().call_deferred("add_child", new_orb)
		"fast":
			get_parent().call_deferred("add_child", new_orb.duplicate())
		"tank":
			for i in 2:
				get_parent().call_deferred("add_child", new_orb.duplicate())
		"boss":
			for i in 3:
				get_parent().call_deferred("add_child", new_orb.duplicate())
