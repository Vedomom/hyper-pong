extends CharacterBody2D
class_name Player_2


@export var speed :float 
@export var  accel :float = 10
@export var lunge_time : float
@export var lunge_cooldown : float
@export var initial_health :float = 100.0
@export var health_lable : Label
@export var initial_damage: float = 10
@export var damage_label: Label
@export var health_bar : ProgressBar
@export var player_1: Player_1
@export var dmg_lbl : Label


const MAX_SPEED = 1300
const MIN_SPEED = 500
var lunge_speed : float 
var current_damage: float
var lunge_timer := 0.0
var lunge_direction : float
var is_dashing = false
var cooldown_timer:= 0.0
var is_dead : bool = false

var curve_power : float = 0
var can_dash : bool = false
var health : float

var whiplash_sleep_timer :float = 0.5
var damage_mult := 0.2
var leech_power := 0.0

var health_bar_sb 

var initial_label_font_size : int
var initial_damage_font_size : int

signal player_shot()  
signal player_scored()
signal player_damaged()
signal player_died()
signal round_up()

func _ready() -> void:
	current_damage = initial_damage	
	lunge_speed = speed
	health = initial_health
	health_bar.max_value = initial_health
	health_bar.value = health

	initial_label_font_size = health_lable.label_settings.font_size
	initial_damage_font_size = damage_label.label_settings.font_size

	health_bar_sb = StyleBoxFlat.new()
	health_bar.add_theme_stylebox_override("fill", health_bar_sb)
	health_bar_sb.bg_color = Color.LIGHT_GREEN



func _physics_process(delta: float) -> void:
	
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)
	#var direction_H := Input.get_axis("Left", "Right")
	var direction_V := Input.get_axis("P2_Up", "P2_Down")
	if direction_V and (!is_dead and !player_1.is_dead) :
		if Input.is_action_just_pressed("P2_Roll") and lunge_timer <= 0.0 and cooldown_timer <= 0.0 and can_dash:
			lunge_timer = lunge_time
			lunge_direction = direction_V
			cooldown_timer = lunge_cooldown
		
		if lunge_timer > 0.0 :
			velocity.y = lunge_speed * lunge_direction
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
	

	velocity.x = 0.0
	position.x = clampf(position.x, 1813, 1813)
	lunge_timer -= delta
	cooldown_timer -= delta

	move_and_slide()


func death():
	is_dead = true
	player_died.emit()
