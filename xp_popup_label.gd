extends Node2D

func _ready():
	$AnimationPlayer.play("popup")
	await $AnimationPlayer.animation_finished
	queue_free()

func set_value(amount: int):
	$Label.text = "+" + str(amount) + " XP" 
