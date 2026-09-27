extends CharacterBody2D

@export var initial_speed := 200.0
@export var score_lable : Label
@export var speedStep : float
var direction := Vector2(-1, randf())
var speed := initial_speed
var score_count := 0

func _physics_process(delta: float) -> void:
	var coll_info = move_and_collide(velocity * delta)
	
	if coll_info:
		direction = direction.bounce(coll_info.get_normal())
		if coll_info.get_collider().name == "Player":
			speed += speedStep
			score_count += 1
			score_lable.text = str(score_count)

	velocity = direction * speed 
	
	move_and_collide(velocity * delta)
