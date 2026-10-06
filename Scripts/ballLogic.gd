extends CharacterBody2D

@export var initial_speed := 200.0
@export var score_lable : Label
@export var speedStep : float
@export var player: CharacterBody2D
@export var cpu : CharacterBody2D
@export var trail : Line2D
@export var trail_length : int = 10
@export var end_pop : Control

var direction :Vector2
var speed := 0.0
var score_count := 0
var is_reset := true
var curve : float = 0.0
var curve_sign : int
var prev_pos : Vector2
var future_pos : Vector2


func _ready() -> void:
	trail.clear_points()
	direction = Vector2(get_random_direction() ,randf())

func _physics_process(delta: float) -> void:

	trail.add_point(position)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)


	var coll_info = move_and_collide(velocity * delta)	


	if prev_pos:
		var pos_diff = position - prev_pos
		if abs(pos_diff) == Vector2.ZERO and !is_reset:
			reset(coll_info, true)

	if coll_info:
		direction = direction.bounce(coll_info.get_normal())
		direction.y = clamp(direction.y, -1, 1)
		direction.x = 1 * sign(direction.x)
		curve = move_toward(curve, 0, 0.1)
		curve_sign = sign(curve)
		if coll_info.get_collider().name == "Player" or coll_info.get_collider().name == "CPU":
			coll_info.get_collider().current_damage *= 1 + (0.2)
			speed += speedStep
			score_count += 1
			score_lable.text = str(score_count)
			if coll_info.get_collider().velocity.y:
				if coll_info.get_collider().velocity.y > coll_info.get_collider().speed:
					curve = 0.8
				else :
					curve = 0.5
				curve_sign = -sign(coll_info.get_collider().velocity.y)
		
		if coll_info.get_collider().name == "Player" and direction.x != 1:
			direction.x = 1
			
		
		if coll_info.get_collider().name == "CPU" and direction.x != -1:
			direction.x = -1


		if coll_info.get_collider().name == "WallLeft" or coll_info.get_collider().name == "WallRight" :
			reset(coll_info)


	if Input.is_action_pressed("Hit") and is_reset and !(player.is_dead or cpu.is_dead):

		speed = initial_speed
		score_count = 0
		score_lable.text = str(score_count)
		direction = Vector2(get_random_direction(), randf())
		if cpu.is_dead or player.is_dead:
			cpu.health = 100
			player.health = 100
			player.is_dead = false
			cpu.is_dead = false
		is_reset = false
	


	if player.is_dead:
		end_pop.end_text = "You Died..."
		end_pop.visible = true

	if cpu.is_dead:
		end_pop.end_text = "You Win!"
		end_pop.visible = true



	direction.y += curve * delta * curve_sign 
	velocity = direction * speed 

	position = clamp(position, Vector2(18, 18), Vector2(1920 -18, 1080 -18))

	prev_pos = position

	move_and_collide(velocity * delta)


func deduct_health(subject, damage):
	
	subject.health -= damage
	subject.health = clampf(subject.health, 0.0, 100.0)
	
func reset(coll_info, is_stuck = null):
			trail.clear_points()
			var last_pos = position
			position = Vector2(960, 540)

			if coll_info:
				if coll_info.get_collider().name == "WallLeft":
					deduct_health(player, cpu.current_damage)
				elif coll_info.get_collider().name == "WallRight" :
					deduct_health(cpu, player.current_damage)
			if is_stuck:
				if last_pos.x >= 1800:
					deduct_health(cpu, player.current_damage)
				else :
					deduct_health(player, cpu.current_damage)

			player.current_damage = player.initial_damage
			cpu.current_damage = cpu.initial_damage
			score_count = 0
			score_lable.text = str(score_count)
			speed = 0
			is_reset = true

func get_random_direction() -> int:
	var randir = randi_range(-1, 1)
	
	if randir != 0:
		return randir
	else:
		return get_random_direction()
