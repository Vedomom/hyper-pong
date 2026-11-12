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

@export var bounce_sfx : AudioStreamPlayer
@export var goal_sfx: AudioStreamPlayer

@export var pause_menu : Control

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


	player_1.round_up.connect(next_round)
	player_1.player_died.connect(update_score.bind(player_2))
	player_2.player_died.connect(update_score.bind(player_1))
	ball.bounced.connect(play_bounce_sfx)
	player_1.player_scored.connect(play_goal_sfx)
	player_2.player_scored.connect(play_goal_sfx)
	player_1.player_died.connect(play_long_goal_sfx)
	player_2.player_died.connect(play_long_goal_sfx)
	

	MusicPlayer.play()




func _process(_delta: float) -> void:
	if (p1_score >= 5 or p2_score >= 5) and not is_ended:
		end_game()
		is_ended = true
	

	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			get_tree().paused = true
			pause_menu.show()



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
		MusicPlayer.stream_paused = false

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
	if scorer == player_1:
		p1_score += 1
		manage_score(p1_score, p1_score_label)
	if scorer == player_2:
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



func manage_health(player):
	player.health_bar.value = move_toward(player.health_bar.value, player.health, 0.2*abs(player.health_bar.value - player.health))
	player.health_lable.text = "%.1f" %player.health
	player.health = clamp(player.health, 0.0, player.initial_health)
	if player.health <= 0.0 and !player.is_dead:
		player.death()
	
	if player.health <= player.initial_health/4:
		player.health_lable.label_settings.font_color = lerp(player.health_lable.label_settings.font_color, Color.RED, 0.1)
		player.health_bar_sb.bg_color = lerp(player.health_bar_sb.bg_color, Color.RED, 0.1)
	elif player.health <= player.initial_health/2:
		player.health_lable.label_settings.font_color = lerp(player.health_lable.label_settings.font_color, Color.YELLOW, 0.1)
		player.health_bar_sb.bg_color = lerp(player.health_bar_sb.bg_color, Color.YELLOW, 0.1)
	else: 
		player.health_lable.label_settings.font_color = lerp(player.health_lable.label_settings.font_color, Color.LIGHT_GREEN, 0.1)
		player.health_bar_sb.bg_color = lerp(player.health_bar_sb.bg_color, Color.LIGHT_GREEN, 0.1)




func manage_damage(player, opponent):
	player.damage_label.text = "%.2f" %move_toward(float(player.damage_label.text), player.current_damage, 0.5*abs(player.current_damage-float(player.damage_label.text)))
	if abs(player.current_damage-float(player.damage_label.text)) <= 0.05:
		player.damage_label.text = "%.2f" %player.current_damage
	if player.current_damage > opponent.health:
		player.damage_label.label_settings.font_color = lerp(player.damage_label.label_settings.font_color, Color(1, 0.43, 0.73), 0.1)
		player.dmg_lbl.label_settings.font_color = lerp(player.dmg_lbl.label_settings.font_color, Color(1, 0.43, 0.73), 0.1)
	elif player.current_damage > opponent.health/2:
		player.damage_label.label_settings.font_color = lerp(player.damage_label.label_settings.font_color, Color(0.85, 0.50, 1.0), 0.1)
		player.dmg_lbl.label_settings.font_color = lerp(player.dmg_lbl.label_settings.font_color, Color(0.85, 0.50, 1.0), 0.1)
	else:
		player.damage_label.label_settings.font_color = lerp(player.damage_label.label_settings.font_color, Color(0.53, 0.9, 1.0), 0.1)
		player.dmg_lbl.label_settings.font_color = lerp(player.dmg_lbl.label_settings.font_color, Color(0.53, 0.9, 1.0), 0.1)


func play_bounce_sfx():
	bounce_sfx.play()

func play_goal_sfx():
	goal_sfx.stream = AudioStreamWAV.load_from_file("res://Resources/SFX/goal.wav")
	goal_sfx.play()

func play_long_goal_sfx():
	MusicPlayer.stream_paused = true
	goal_sfx.stream = AudioStreamWAV.load_from_file("res://Resources/SFX/goal_short.wav")
	goal_sfx.play()
