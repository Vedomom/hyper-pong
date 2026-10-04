extends CharacterBody2D

@export var speed: float = 500
@export var accel: float = 10
@export var ball: CharacterBody2D
@export var paddle_shape : CollisionShape2D    
@export var health :float = 100.0
@export var health_lable : Label
@export var initial_damage: float = 10
@export var damage_label: Label
@export var player: CharacterBody2D

var current_damage: float
var dist : float
var step_size : float
var win_height : float
var paddle_height : float
var is_dead : bool = false

func _ready() -> void:
	current_damage = initial_damage
	win_height = get_viewport_rect().size.y
	paddle_height = paddle_shape.shape.size.y
	print(paddle_height)

func _physics_process(delta: float) -> void:
	dist = position.y - ball.position.y
	if abs(dist) > speed * delta:
		#step_size = speed * delta * sign(dist)
		velocity.y = lerp(velocity.y, speed *  -sign(dist), accel * delta)
	elif position.y -paddle_height < ball.position.y  and ball.position.y < position.y +paddle_height:
		#step_size = dist
		velocity.y = move_toward(velocity.y, 0, accel * delta)
	
	manage_health()
	manage_damage()
	move_and_slide()
	#position.y -= step_size
	#position.y = clamp(position.y, paddle_height, win_height - paddle_height)
	position.x = clampf(position.x, 1895, 1895)

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
	if current_damage > player.health:
		damage_label.label_settings.font_color = Color(1, 0.43, 0.73)
	elif current_damage > player.health / 2:
		damage_label.label_settings.font_color = Color(0.85, 0.50, 1.0)
	else:
		damage_label.label_settings.font_color = Color(0.53, 0.9, 1.0)
