extends CharacterBody2D


@export var speed :float = 500.0
@export var  accel :float = 10
@export var lunge_speed : float
@export var lunge_time : float
@export var lunge_cooldown : float
@export var health :float = 100.0
@export var score_lable: Label
@export var health_lable : Label

var lunge_timer := 0.0
var lunge_direction : float
var is_dashing = false
var cooldown_timer:= 0.0
var is_dead : bool = false

func _physics_process(delta: float) -> void:
	
	#var direction_H := Input.get_axis("Left", "Right")
	var direction_V := Input.get_axis("Up", "Down")
	if direction_V:
		if Input.is_action_just_pressed("Roll") and lunge_timer <= 0.0 and cooldown_timer <= 0.0:
			lunge_timer = lunge_time
			lunge_direction = direction_V
			cooldown_timer = lunge_cooldown
		

		if lunge_timer <= 0.0 :
			velocity.y = lerp(velocity.y, direction_V * speed, accel * delta)
	else:
		if lunge_timer <= 0.0 :
			velocity.y = move_toward(velocity.y, 0, 250)
	
	if lunge_timer > 0.0 :
		velocity.y = lunge_speed * lunge_direction
	
	if cooldown_timer > 0.0:
		modulate = lerp(modulate, Color(1, 1, 0.22), delta * accel *0.8)
	else:
		modulate = lerp(modulate, Color(1, 1, 1), delta * accel* 0.8)
	
	health_lable.text = str(health)

	if health <= 0.0 :
		death()
	
	if health < 60:
		health_lable.label_settings.font_color = Color(1, 1, 0.22, 1)
	elif health < 30:
		health_lable.label_settings.font_color = Color(1, 0, 0, 1)
	else: 
		health_lable.label_settings.font_color = Color(0, 1, 0.22, 1)

	velocity.x = 0.0
	position.x = clampf(position.x, 25, 25)
	lunge_timer -= delta
	cooldown_timer -= delta

	move_and_slide()


func death():
	score_lable.text = "You died"
	is_dead = true
