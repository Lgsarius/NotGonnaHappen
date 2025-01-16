extends Node2D

@onready var animation = %AnimatedSprite2D
func play_idle_animation():
	animation.play("idle")

func play_run_animation():
	animation.play("run")
