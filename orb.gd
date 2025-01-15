extends Area2D

@export var experience = 1
var target = null
var speed = 0
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta
		

func collect():
	queue_free()
	return experience
