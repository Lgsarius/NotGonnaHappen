extends Node2D

func _ready():
	$AnimationPlayer.play("level_up")
	await $AnimationPlayer.animation_finished
	queue_free() 