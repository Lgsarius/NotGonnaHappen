extends Sprite2D

@export var move_speed: float = 100.0
@export var change_direction_time: float = 2.0
@export var movement_range: float = 100.0

var initial_position: Vector2
var target_position: Vector2
var time_since_direction_change: float = 0.0

func _ready():
	initial_position = position
	_get_new_target()

func _process(delta):
	time_since_direction_change += delta
	
	if time_since_direction_change >= change_direction_time:
		_get_new_target()
		time_since_direction_change = 0.0
	
	# Move towards target position
	var direction = (target_position - position).normalized()
	position += direction * move_speed * delta
	
	# Optional: Add a slight floating effect
	position.y += sin(Time.get_ticks_msec() * 0.005) * 0.3

func _get_new_target():
	# Generate a new random position within range of the initial position
	var random_x = randf_range(-movement_range, movement_range)
	var random_y = randf_range(-movement_range, movement_range)
	target_position = initial_position + Vector2(random_x, random_y) 