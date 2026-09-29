extends CharacterBody2D

@export var speed: float = 500
@export var accel: float = 10
@export var ball: CharacterBody2D
@export var paddle_shape : CollisionShape2D    
@export var health :float = 100.0
@export var health_lable : Label
var dist : float
var step_size : float
var win_height : float
var paddle_height : float

func _ready() -> void:
	win_height = get_viewport_rect().size.y
	paddle_height = paddle_shape.shape.size.y
	print(paddle_height)

func _physics_process(delta: float) -> void:

	dist = position.y - ball.position.y
	if abs(dist) > speed * delta:
		step_size = speed * delta * sign(dist)
	else:
		step_size = dist
	

	health_lable.text = str(health)

	if health <= 0.0 :
		death()
	
	if health < 30:
		health_lable.label_settings.font_color = Color(1, 0, 0, 1)

	position.y -= step_size

	position.y = clamp(position.y, paddle_height, win_height - paddle_height)
	

	position.x = clampf(position.x, 1895, 1895)

func death():
	ball.score_lable.text = "You Win"
