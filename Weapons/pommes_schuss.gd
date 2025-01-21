extends Area2D

var level = 1
var health = 1
var speed = 100
var damage  = 5
var knockback_amount = 100
var attack_size  =1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO
signal remove_from_array(object)
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(90)
	match level:
		1:
			health = 1
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			health = 1
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			health = 2
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			health = 2
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func _physics_process(delta: float) -> void:
	position += angle*speed*delta
	
	
func enemy_hit(charge = 1):
	health -= charge
	if health <= 0:
		remove_from_array.emit(self)
		queue_free()


func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free()
