extends Node
class_name MultManager

var player_1 : Player_1
var player_2 : Player_2
var ball : MultBall
var ui_container : Node

var p1_score : int = 0
var p2_score : int = 0

@export var p1_score_label : Label
@export var p2_score_label : Label


var round_number : int
@export var round_label : Label
var max_rounds : int
var is_ended := false

const E_MAXSPEED = 1300
const E_MINSPEED = 300


func _ready() -> void:
	get_tree().paused = false
	for node in get_parent().get_children():
		if node is Player_1:
			player_1 = node
		if node is Player_2:
			player_2 = node 
		if node is MultBall:
			ball = node
		if node.name == "UI":
			ui_container = node
	

	round_number = 1
	round_label.text = "Round : %d" %[round_number]

	p1_score = 4

	player_1.round_up.connect(next_round)
	player_1.player_died.connect(update_score.bind(player_2))
	player_2.player_died.connect(update_score.bind(player_1))

func _process(_delta: float) -> void:
	if (p1_score >= 5 or p2_score >= 5) and not is_ended:
		end_game()
		is_ended = true
	


func next_round():

	if is_ended:
		pass
	else:
		
		#player_1
		if round_number <= 5 :
			player_1.initial_health += 10
			player_2.initial_health += 10
			print(player_2.initial_health)
		player_1.health = player_1.initial_health
		player_1.current_damage = player_1.initial_damage

		player_1.health_bar.max_value = player_1.initial_health
		player_1.health_bar.value = player_1.health
		player_1.is_dead = false


		#player_2
		player_2.health = player_2.initial_health
		player_2.current_damage = player_2.initial_damage
		player_2.health_bar.max_value = player_2.initial_health
		player_2.health_bar.value = player_2.health
		player_2.is_dead = false
		

		#ball
		ball.game_won = false
		get_tree().paused = false
		print("Game state : ", get_tree().paused)
	
		round_number += 1
		round_label.text = "Round : %d" %[round_number]

func end_game():
	ball.end_pop.queue_free()
	var winscrn = load("res://Scenes/Multiplayer/win_screen_Multi.tscn").instantiate()
	ui_container.add_child(winscrn)
	winscrn.p1_score_label.text = str(clamp(p1_score, 0, 5))
	winscrn.p2_score_label.text = str(clamp(p2_score, 0, 5))
	if p1_score > p2_score:
		winscrn.winner_label.text = "Winner : P1"
		winscrn.p1_score_label.label_settings.font_color = Color.LIME_GREEN
		winscrn.p2_score_label.label_settings.font_color = Color.CRIMSON
	else :
		winscrn.winner_label.text = "Winner : P2"
		winscrn.p2_score_label.label_settings.font_color = Color.LIME_GREEN
		winscrn.p1_score_label.label_settings.font_color = Color.CRIMSON

	get_tree().paused = true

func update_score(scorer : CharacterBody2D):
	if scorer is Player_1:
		p1_score += 1
		manage_score(p1_score, p1_score_label)
	if scorer is Player_2:
		p2_score += 1
		manage_score(p2_score, p2_score_label)
	

func manage_score(score : int,score_lbl: Label):
	score_lbl.text = str(score)
	if score >= 4 :
		score_lbl.label_settings.font_color = Color.CRIMSON
	elif score >= 2 :
		score_lbl.label_settings.font_color = Color.MAGENTA
	else:
		score_lbl.label_settings.font_color = Color.PALE_TURQUOISE
