extends Node
class_name Manager

var player : Player
var enemy : Enemy
var ball : Ball

var round_number : int
@export var round_label : Label
var max_rounds : int

func _ready() -> void:
	for node in get_parent().get_children():
		if node is Player:
			player = node
		if node is Enemy:
			enemy = node 
		if node is Ball:
			ball = node
	

	round_number = 1
	max_rounds = 10
	round_label.text = "%d / %d" %[round_number ,max_rounds]

	player.round_up.connect(next_round)


func next_round():
	round_number += 1
	round_label.text = "%d / %d" %[round_number, max_rounds]

	#player
	player.health = player.initial_health
	player.current_damage = player.initial_damage

	#change map layout

	#enemy - spawn a new enemy faster with more abilities
	enemy.health = 1
	enemy.current_damage = enemy.initial_damage
	enemy.is_dead = false

	#ball
	ball.game_won = false
