extends CharacterBody2D
class_name Ball

@export var initial_speed := 200.0
@export var score_lable : Label
@export var speedStep : float
@export var player: Player
@export var cpu : Enemy
@export var trail : Line2D
@export var trail_length : int = 10
@export var ui_container : Node
@export var bounce_particle : GPUParticles2D
@export var goal_particle : GPUParticles2D
@export var ball_light : PointLight2D
@export var shape : ColorRect

var direction :Vector2
var speed := 0.0
var score_count := 0
var is_reset := true
var curve : float = 0.0
var curve_sign : int
var prev_pos : Vector2
var future_pos : Vector2
var game_won :bool = false
var coll_info
var can_move := false
var win_pop
var end_pop


signal bounced()

func _ready() -> void:
	trail.clear_points()
	direction = Vector2(get_random_direction() ,randf())
	cpu.enemy_scored.connect(TextAnimation.goal_particle_animation.bind(goal_particle, 1))
	player.player_scored.connect(TextAnimation.goal_particle_animation.bind(goal_particle, -1))
	player.player_died.connect(round_over.bind(player))
	cpu.enemy_died.connect(round_over.bind(cpu))
	ball_light.energy = 0.0

func _physics_process(delta: float) -> void:

	trail.add_point(position)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)


	coll_info = move_and_collide(velocity * delta)	

	#hadle if ball stuck
	if prev_pos:
		var pos_diff = position - prev_pos
		if abs(pos_diff) == Vector2.ZERO and !is_reset:
			reset(true)

	if coll_info:
		
		direction = direction.bounce(coll_info.get_normal())
		direction.y = clamp(direction.y, -1, 1)
		direction.x = 1 * sign(direction.x)
		curve = move_toward(curve, 0, 0.5)
		curve_sign = sign(curve)

		if coll_info.get_collider() == player and direction.x != 1:
			direction.x = 1
			
		
		if coll_info.get_collider() == cpu and direction.x != -1:
			direction.x = -1
		
		if coll_info.get_collider() == player or coll_info.get_collider() == cpu:
			bounced.emit()
			coll_info.get_collider().current_damage *= 1 + coll_info.get_collider().damage_mult
			TextAnimation.pop_animation(coll_info.get_collider().damage_label, -20, coll_info.get_collider().initial_damage_font_size)
			TextAnimation.rot_animation(coll_info.get_collider().damage_label, -0.8)
			if coll_info.get_collider() is Player:
				player.player_shot.emit()
			else:
				cpu.enemy_shot.emit()
			speed += speedStep
			score_count += 1
			score_lable.text = str(score_count)
			if coll_info.get_collider().velocity.y:
				if coll_info.get_collider().velocity.y > coll_info.get_collider().speed:
					curve = coll_info.get_collider().curve_power + 0.2
				else :
					curve = coll_info.get_collider().curve_power
				curve_sign = -sign(coll_info.get_collider().velocity.y)
			
			if speed > 650:
				HitStop.hit_stop(0.24)
				ball_light.energy = lerp(ball_light.energy, 5.0, 5*delta)
			elif speed > 450:
				HitStop.hit_stop(0.14)
				ball_light.energy = lerp(ball_light.energy, 3.0, 5*delta)
		
		elif coll_info.get_collider().name == "WallLeft" or coll_info.get_collider().name == "WallRight" :
			reset()
		else :
			if coll_info.get_position().y > 80 :
				bounce_particle.process_material.emission_shape_offset.y = 15
			else:
				bounce_particle.process_material.emission_shape_offset.y = -15
			bounce_particle.restart()
			bounced.emit()

	if Input.is_action_pressed("Hit") and is_reset and !(player.is_dead or cpu.is_dead):

		speed = initial_speed
		score_count = 0
		score_lable.text = str(score_count)
		direction = Vector2(get_random_direction(), randf_range(-1, 1))
		if cpu.is_dead or player.is_dead:
			cpu.health = 100
			player.health = 100
			player.is_dead = false
			cpu.is_dead = false
		is_reset = false
		can_move = true
	


	





	direction.y += curve * delta * curve_sign 

	if can_move:
		velocity = direction * speed 

	position = clamp(position, Vector2(18, 18), Vector2(1920 -18, 1080 -18))

	prev_pos = position

	move_and_collide(velocity * delta)


func deduct_health(subject, damage):
	
	subject.health -= damage
	subject.health = clampf(subject.health, 0.0, subject.initial_health)
	TextAnimation.pop_animation(subject.health_lable, 15, subject.initial_label_font_size)
	TextAnimation.rot_animation(subject.health_lable, -0.8)

	
func reset(is_stuck : bool = false):
			var last_pos = position
			if coll_info:
				if coll_info.get_collider().name == "WallLeft":
					player.player_damaged.emit()
					cpu.enemy_scored.emit()
					await get_tree().create_timer(0.02).timeout
					deduct_health(player, cpu.current_damage)
				elif coll_info.get_collider().name == "WallRight" :
					player.player_scored.emit()
					cpu.enemy_damaged.emit()
					await get_tree().create_timer(0.02).timeout
					deduct_health(cpu, player.current_damage)
			
			if is_stuck:
				if last_pos.x >= 1800:
					player.player_scored.emit()
					cpu.enemy_damaged.emit()
					await get_tree().create_timer(0.03).timeout
					deduct_health(cpu, player.current_damage)
				else :
					player.player_damaged.emit()
					cpu.enemy_scored.emit()
					await get_tree().create_timer(0.03).timeout
					deduct_health(player, cpu.current_damage)
			trail.clear_points()
			player.current_damage = player.initial_damage
			cpu.current_damage = cpu.initial_damage
			score_count = 0
			score_lable.text = str(score_count)
			speed = 0
			velocity = Vector2.ZERO
			is_reset = true
			can_move = false
			ball_light.energy = 0
			position = Vector2(960, 540)
			shape.hide()
			await get_tree().create_timer(0.4).timeout
			if !player.is_dead and !cpu.is_dead:
				shape.show()

func get_random_direction() -> int:
	var randir = randi_range(-1, 1)
	
	if randir != 0:
		return sign(randir)
	else:
		return get_random_direction()

func round_over(deceased):
	TextAnimation.pop_animation(deceased.health_lable, 15, deceased.initial_label_font_size)
	TextAnimation.rot_animation(deceased.health_lable, -0.8)
	Engine.time_scale *= 0.1
	await get_tree().create_timer(0.4).timeout
	Engine.time_scale = 1.0
	if deceased is Enemy:
		get_tree().paused = true
		win_pop = load("res://Scenes/win_pop_up.tscn").instantiate()
		ui_container.add_child(win_pop)
		game_won = true
	elif deceased is Player:
		get_tree().paused = true
		end_pop = load("res://Scenes/end_pop_up.tscn").instantiate()
		ui_container.add_child(end_pop)
		end_pop.end_text = "You Died..."
		end_pop.visible = true
