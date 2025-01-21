extends CharacterBody2D


@export var movement_speed = 20
@export var health  = 30
@export var damage  =1
@onready var knockback_recovery  =3.5
var knockback = Vector2.ZERO


@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D
@onready var HitBox = $HitBox
@onready var exp_gem = preload("res://orb.tscn")
signal remove_from_array(object)


func _ready():
	
	sprite.play("walk")
func _physics_process(_delta: float) -> void:
	HitBox.damage = damage
	knockback = knockback.move_toward(Vector2.ZERO,knockback_recovery)
	#var dir = global_position.direction_to(player.global_position)
	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	velocity = dir * movement_speed
	velocity += knockback
	move_and_slide()
	
	if dir.x > 0.1:
		sprite.flip_h = true
	elif dir.x < -0.1:
		sprite.flip_h = false

func makepath():
	nav_agent.target_position = player.global_position
	
	
func death():
	emit_signal("remove_from_array",self)
	var new_orb  =exp_gem.instantiate()
	new_orb.global_position = global_position
	get_parent().call_deferred("add_child",new_orb)
	queue_free()
	
func _on_hurt_box_hurt(inc_damage,angle,knockback_amount):
	health -= inc_damage
	knockback = angle * knockback_amount
	if health <= 0:
		death()
		


func _on_path_timer_timeout() -> void:
	makepath()
