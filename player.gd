extends CharacterBody2D
signal loot_collected
signal health_depleted

const MAX_HEALTH = 100.0
var health = MAX_HEALTH
var is_invincible = false
var invincibility_timer = 0.0

func _ready() -> void:
	%ProgressBar.max_value = MAX_HEALTH
	%ProgressBar.value = health

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		# Regenerate health when standing still
		if health < MAX_HEALTH:
			health = min(health + 10.0 * delta, MAX_HEALTH)
			%ProgressBar.value = health
	
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false
			modulate = Color(1, 1, 1, 1)
	
	const DAMAGE_RATE = 25.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0 and not is_invincible:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		health = max(0, health)  # Prevent negative health
		%ProgressBar.value = health
		
		if health <= 0.0:
			health_depleted.emit()
		else:
			# Add invincibility frames when hit
			is_invincible = true
			invincibility_timer = 0.5
			modulate = Color(1, 1, 1, 0.5)

func heal(amount: float) -> void:
	health = min(health + amount, MAX_HEALTH)
	%ProgressBar.value = health

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var orb = area.collect()
		heal(10.0)  # Heal when collecting orbs
		loot_collected.emit()
