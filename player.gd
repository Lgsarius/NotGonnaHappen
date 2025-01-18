extends CharacterBody2D
signal loot_collected
signal health_depleted
signal level_up


@onready var levelPanel = $LevelUp
@onready var upgradeOptions = %UpgradeOptions
@onready var itemOptions =preload("res://Utility/item_option.tscn")

var health = 100.0
var maxhealth =100.0
var movement_speed = 200
var armor = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
var experience = 0
var experience_level = 1
var collected_experience = 0
var collected_upgrades  = []
var upgrade_options = []
const DAMAGE_RATE = 100


var dash_speed = 600
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
	movement()
	
	
	
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
		
		
	
		
func movement():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_sprite(false)
	elif mov.x < 0:
		sprite.flip_sprite(true)
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		$dash_timer.start()
		dash_cd_timer.start()
		
	if dashing:
		velocity = mov.normalized() * dash_speed
	else:
		velocity = mov.normalized() * movement_speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		%Old_man.play_run_animation()
	else:
		%Old_man.play_idle_animation()
	
	

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		var xp_label = preload("res://xp_popup_label.tscn").instantiate()
		var random_angle = randf() * 2 * PI
		var random_distance = randf_range(30, 50)
		var random_pos = Vector2(cos(random_angle), sin(random_angle)) * random_distance
		xp_label.position = position + random_pos
		xp_label.set_value(gem_exp)
		get_parent().add_child(xp_label)
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
	level_up.emit()
	score.text = str(experience_level)
	print("LevelUP")
	levelPanel.visible = true
	levelPanel.process_mode = Node.PROCESS_MODE_ALWAYS
	var options = 0
	var optionsmax = 3
	var option_choice = itemOptions.instantiate()
	option_choice.item = get_random_item()	
	upgradeOptions.add_child(option_choice)
	option_choice.get_child(-1).grab_focus()
	options +=1
	while options < optionsmax:
		option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()	
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"health1","health2","health3","health4":
			maxhealth += 20
			health+=20
			%ProgressBar.max_value = maxhealth
			%ProgressBar.value = health
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			health += 20
			health = clamp(health,0,maxhealth)
	
	for child in upgradeOptions.get_children():
		child.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	get_tree().paused = false
	

func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	$dash_cooldown.stop()
	

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add  =false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
	
