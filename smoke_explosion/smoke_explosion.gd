extends Node2D

@onready var animation = $AnimatedSprite2D
func _ready():
	
	animation.play("default")
	await animation.animation_finished
	queue_free()
