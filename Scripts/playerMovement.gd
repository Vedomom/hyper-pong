extends CharacterBody2D


@export var speed :float = 500.0
@export var  accel :float = 10
@export var lunge_speed : float
@export var lunge_time : float
@export var lunge_cooldown : float
@export var health :float = 100.0
@export var health_lable : Label
@export var initial_damage: float = 10
@export var damage_label: Label
@export var cpu: CharacterBody2D

var current_damage: float
var lunge_timer := 0.0
var lunge_direction : float
var is_dashing = false
var cooldown_timer:= 0.0
var is_dead : bool = false

func _ready() -> void:
	current_damage = initial_damage	


func _physics_process(delta: float) -> void:
	

	#var direction_H := Input.get_axis("Left", "Right")
	var direction_V := Input.get_axis("Up", "Down")
	if direction_V and (!is_dead and !cpu.is_dead) :
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
	

	manage_health()
	manage_damage()


	velocity.x = 0.0
	position.x = clampf(position.x, 25, 25)
	lunge_timer -= delta
	cooldown_timer -= delta

	move_and_slide()


func death():
	is_dead = true

func manage_health():
	health_lable.text = "%.1f" %health
	if health <= 0.0 :
		death()
	
	if health < 30:
		health_lable.label_settings.font_color = Color(1, 0, 0, 1)
	elif health < 60:
		health_lable.label_settings.font_color = Color(1, 1, 0.22, 1)
	else: 
		health_lable.label_settings.font_color = Color(0, 1, 0.22, 1)

func manage_damage():
	damage_label.text = "%.2f" %current_damage
	if current_damage > cpu.health:
		damage_label.label_settings.font_color = Color(1, 0.43, 0.73)

	elif current_damage > cpu.health / 2:
		damage_label.label_settings.font_color = Color(0.94, 1.0, 0.25)
	else:
		damage_label.label_settings.font_color = Color(0.53, 0.9, 1.0)
