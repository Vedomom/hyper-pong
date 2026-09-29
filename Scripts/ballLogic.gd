extends CharacterBody2D

@export var initial_speed := 200.0
@export var score_lable : Label
@export var speedStep : float
@export var player: CharacterBody2D
@export var cpu : CharacterBody2D
@export var trail : Line2D
@export var trail_length : int = 10
var direction := Vector2(-1, randf())
var speed := 0.0
var score_count := 0
var is_reset := true
var curve : float = 0.0
var curve_sign : int


func _ready() -> void:
	trail.clear_points()

func _physics_process(delta: float) -> void:

	trail.add_point(position)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)


	var coll_info = move_and_collide(velocity * delta)	
	if coll_info:
		direction = direction.bounce(coll_info.get_normal())
		direction.y = clamp(direction.y, -1, 1)
		direction.x = 1 * sign(direction.x)
		curve = move_toward(curve, 0, 0.1)
		curve_sign = sign(curve)
		if coll_info.get_collider().name == "Player" or coll_info.get_collider().name == "CPU":
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


		if coll_info.get_collider().name == "WallLeft" or coll_info.get_collider().name == "WallRight" or (coll_info.get_collider().name == "CPU" and !velocity and !is_reset):
			trail.clear_points()
			position = Vector2(960, 540)
			
			if coll_info.get_collider().name == "WallLeft":
				deduct_health(player)
			else :
				deduct_health(cpu)

			speed = 0
			score_count = 0
			score_lable.text = str(score_count)
			direction = Vector2(-1, randf())
			is_reset = true


	if Input.is_action_pressed("Hit") and is_reset:
		speed = initial_speed
		is_reset = false
	



	direction.y += curve * delta * curve_sign 
	velocity = direction * speed 

	position = clamp(position, Vector2(18, 18), Vector2(1920 -18, 1080 -18))


	move_and_collide(velocity * delta)


func deduct_health(subject):
	subject.health -= score_count
	subject.health = clampf(subject.health, 0.0, 100.0)
	
