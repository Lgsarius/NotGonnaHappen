extends Node2D

@onready var animation = %AnimatedSprite2D
func play_idle_animation():
	animation.play("default")

func play_run_animation():
	animation.play("default")
func flip_sprite():
	if animation.is_flipped_h():
		animation.set_flip_h(false)
	else: 
		animation.set_flip_h(true)
