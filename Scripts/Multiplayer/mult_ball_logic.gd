extends CharacterBody2D
class_name MultBall

@export var initial_speed := 350.0
@export var score_lable : Label
@export var speedStep : float
@export var player: Player_1
@export var player2 : Player_2
@export var trail : Line2D
@export var trail_length : int = 10
@export var ui_container : Node

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
var end_pop

func _ready() -> void:
	trail.clear_points()
	direction = Vector2(get_random_direction() ,randf())
	player.player_died.connect(round_over.bind(self))
	player2.player_died.connect(round_over.bind(self))

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
		if coll_info.get_collider() == player or coll_info.get_collider() == player2:
			coll_info.get_collider().current_damage *= 1 + coll_info.get_collider().damage_mult
			if coll_info.get_collider() is Player_1:
				player.player_shot.emit()
			else:
				player2.player_shot.emit()
			speed += speedStep
			score_count += 1
			score_lable.text = str(score_count)
			if coll_info.get_collider().velocity.y:
				if coll_info.get_collider().velocity.y > coll_info.get_collider().speed:
					curve = coll_info.get_collider().curve_power + 0.2
				else :
					curve = coll_info.get_collider().curve_power
				curve_sign = -sign(coll_info.get_collider().velocity.y)
		
		if coll_info.get_collider() == player and direction.x != 1:
			direction.x = 1
			
		
		if coll_info.get_collider() == player2 and direction.x != -1:
			direction.x = -1


		if coll_info.get_collider().name == "WallLeft" or coll_info.get_collider().name == "WallRight" :
			reset()


	if Input.is_action_pressed("Hit") and is_reset and !(player.is_dead or player2.is_dead):

		speed = initial_speed
		score_count = 0
		score_lable.text = str(score_count)
		direction = Vector2(get_random_direction(), randf_range(-1, 1))
		if player2.is_dead or player.is_dead:
			player2.health = 100
			player.health = 100
			player.is_dead = false
			player2.is_dead = false
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
	
func reset(is_stuck : bool = false):
			trail.clear_points()
			var last_pos = position
			position = Vector2(960, 540)

			if coll_info:
				if coll_info.get_collider().name == "WallLeft":
					player.player_damaged.emit()
					player2.player_scored.emit()
					deduct_health(player, player2.current_damage)
				elif coll_info.get_collider().name == "WallRight" :
					player.player_scored.emit()
					player2.player_damaged.emit()
					deduct_health(player2, player.current_damage)
			if is_stuck:
				if last_pos.x >= 1800:
					deduct_health(player2, player.current_damage)
				else :
					deduct_health(player, player2.current_damage)

			player.current_damage = player.initial_damage
			player2.current_damage = player2.initial_damage
			score_count = 0
			score_lable.text = str(score_count)
			speed = 0
			velocity = Vector2.ZERO
			is_reset = true
			can_move = false

func get_random_direction() -> int:
	var randir = randi_range(-1, 1)
	
	if randir != 0:
		return randir
	else:
		return get_random_direction()


func round_over(deceased : CharacterBody2D):
	get_tree().paused = true
	end_pop = load("res://Scenes/Multiplayer/win_pop_up_Multi.tscn").instantiate()

	ui_container.add_child(end_pop)
	
	if deceased is Player_1:
		end_pop.winner_text = "P2 won"
	else :
		end_pop.winner_text = "P1 won"
	
