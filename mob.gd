extends CharacterBody2D

signal mob_death
var health = 3
var speed = 150
@onready var player = get_node("/root/Game/Player")
@onready var animation = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D

func _ready():
	animation.play("idle")
	pass
	

func _physics_process(delta: float) -> void:
	#var direction = global_position.direction_to(player.global_position)
	#velocity = direction * speed
	#move_and_slide()
	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	velocity = dir * speed
	move_and_slide()
	
func makepath():
	nav_agent.target_position = player.global_position
	

func take_damage():
	health -= 1
	animation.play("hurt")

	
	if health == 0:
		mob_death.emit()
		drop_loot()
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
	
func drop_loot():
	var new_orb = preload("res://orb.tscn").instantiate()
	new_orb.global_position = global_position
	get_parent().call_deferred("add_child",new_orb)


func _on_timer_timeout() -> void:
	makepath()
