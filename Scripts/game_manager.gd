extends Node
class_name Manager

var player : Player
var enemy : Enemy
var ball : Ball

var round_number : int
@export var round_label : Label
var max_rounds : int

const E_MAXSPEED = 1300
const E_MINSPEED = 300

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
	upgrade_enemy()

	#ball
	ball.game_won = false


func upgrade_enemy():
	enemy.speed *= randf_range(1.1, 1.3)
	enemy.speed = clamp(enemy.speed, E_MINSPEED, E_MAXSPEED)

	enemy.accel = randf_range(5, 20)

	enemy.modulate = [Color.ALICE_BLUE, Color.ANTIQUE_WHITE, Color.CORAL, Color.MINT_CREAM, Color.CRIMSON, Color.ORANGE, Color.YELLOW][randi_range(0, 6)]
	enemy.detection_range = randf_range(1.5, 4)

	enemy.initial_damage = randf_range(1, 10)

	add_enemy_upgrades(randi_range(0, 3))


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
			
