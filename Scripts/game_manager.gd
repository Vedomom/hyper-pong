extends Node
class_name Manager

var player : Player
var enemy : Enemy
var ball : Ball
var ui_container : Node

var round_number : int
@export var round_label : Label
var max_rounds : int
var is_ended := false

const E_MAXSPEED = 1300
const E_MINSPEED = 300

func _ready() -> void:
	get_tree().paused = false

	for node in get_parent().get_children():
		if node is Player:
			player = node
		if node is Enemy:
			enemy = node 
		if node is Ball:
			ball = node
		if node.name == "UI":
			ui_container = node
	

	round_number = 1
	max_rounds = 10
	round_label.text = "%d / %d" %[round_number ,max_rounds]

	randomize_enemy_health()
	enemy.health = enemy.initial_health
	enemy.health_bar.value = enemy.health
	enemy.health_bar.max_value = enemy.initial_health
	player.round_up.connect(next_round)


func _process(_delta: float) -> void:
	if ball.game_won and round_number>= 10 and not is_ended:
		end_game()
		is_ended = true
	
	player.health = clamp(player.health, 0.0, player.initial_health)

	if player.is_dead:
		get_tree().paused = true
		ball.end_pop.end_text = "You Died..."
		ball.end_pop.visible = true
		
		





func next_round():

	if round_number >= 10:
		end_game()
	else:

		#player
		if round_number <= 5 :
			player.initial_health += 10
		player.health = player.initial_health
		player.current_damage = player.initial_damage

		player.health_bar.max_value = player.initial_health
		player.health_bar.value = player.health

		#change map layout

		#enemy - change the enemy into a new random one
		upgrade_enemy()
		enemy.health = enemy.initial_health
		enemy.current_damage = enemy.initial_damage
		enemy.is_dead = false
		enemy.health_bar.max_value = enemy.initial_health
		enemy.health_bar.value = enemy.health
		

		#ball
		ball.game_won = false
	
	round_number += 1
	round_label.text = "%d / %d" %[round_number, max_rounds]


func upgrade_enemy():
	enemy.speed += randf_range(20, 100)
	enemy.speed = clamp(enemy.speed, E_MINSPEED, E_MAXSPEED)
	print("speed: ",enemy.speed)

	enemy.accel = randf_range(5, 15)

	enemy.modulate = [Color.SILVER, Color.ANTIQUE_WHITE, Color.CORAL, Color.SPRING_GREEN, Color.CRIMSON, Color.ORANGE, Color.PALE_GOLDENROD, Color.BLUE_VIOLET, Color.DEEP_PINK, Color.HONEYDEW][randi_range(0, 6)]
	enemy.detection_range = randf_range(1.5, 4)

	enemy.initial_damage = randf_range(1, 10)
	randomize_enemy_health()
	var amount = 0

	if round_number <=  2:
		amount = 0
		enemy.damage_mult = 0.1
	
	elif  round_number <= 5:
		amount = 1
		enemy.damage_mult = 0.2
	elif round_number <= 7:
		amount = 2
		enemy.damage_mult = 0.3
	else :
		amount = 3
		enemy.damage_mult = 0.4
		
	
	add_enemy_upgrades(amount)

func randomize_enemy_health():
	if round_number <= 5 :
		enemy.initial_health = randi_range(clamp((round_number*10) - 15, 1, round_number*10), round_number*10)

	else :
		enemy.initial_health = randi_range(50, 150)

func add_enemy_upgrades(amount : int):
	var upgrades_folder = DirAccess.open("res://Scripts/Upgrades/Enemy/Scenes/")
	var upgrades_list = []

	for filename:String in upgrades_folder.get_files():
		upgrades_list.append(upgrades_folder.get_current_dir() + "/" + filename)
	
	upgrades_list.shuffle()

	for child in enemy.get_child(2).get_children():
		child.queue_free()



	if amount > 0:
		for i in range(amount):
			var ugd = load(upgrades_list.pop_front()).instantiate()
			var container = enemy.get_child(2)
			container.add_child(ugd)
			print("Upgrade: ", ugd.name)
			
func end_game():
	ball.win_pop.queue_free()
	var winscrn = load("res://Scenes/win_screen.tscn").instantiate()
	ui_container.add_child(winscrn)
	get_tree().paused = true
