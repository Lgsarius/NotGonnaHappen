extends CharacterBody2D
signal loot_collected
signal health_depleted

var health = 100.0
var experience = 0
var experience_level = 1
var collected_experience = 0
var speed = 300

var dash_speed = 900
var dashing = false
var can_dash  = true
var last_direction:float = 0.0
var percentage_of_time

@onready var sprite = %Old_man
@onready var expBar = %ExperienceBar
@onready var score = %Score
@onready var dash_bar = $Dash_bar
@onready var dash_cd_timer = $dash_cooldown

func _ready() -> void:
	set_expbar(experience,calculate_experiencecap())
	score.text = str(experience_level)
	
func _physics_process(delta: float) -> void:
	
	
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		$dash_timer.start()
		dash_cd_timer.start()
	if direction.x != 0 and sign(direction.x) != sign(last_direction):
		%Old_man.flip_sprite()
		last_direction = direction.x
		
	if dashing:
		velocity = direction * dash_speed
	else:
		velocity = direction * speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		%Old_man.play_run_animation()
	else:
		%Old_man.play_idle_animation()
	
	const DAMAGE_RATE = 100
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()
	if dash_cd_timer.get_time_left() > 0:
		percentage_of_time = ((1 - dash_cd_timer.get_time_left() / dash_cd_timer.get_wait_time()) *100)
		$Dash_bar.value = percentage_of_time
	else:
		$Dash_bar.value = 100

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		loot_collected.emit()
		
		
		
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	set_expbar(experience,exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 *(experience_level-19)*8
	else:
		exp_cap = 255 +(experience_level-39)*12
	return exp_cap

func set_expbar(set_value = 1, set_max_value=100):
	expBar.value = set_value
	expBar.max_value = set_max_value


func levelup():
	score.text = str(experience_level)


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	$dash_cooldown.stop()
