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
	round_label.text = "Round : %d / %d" %[round_number ,max_rounds]
	randomize_enemy_health()
	enemy.health = enemy.initial_health
	enemy.health_bar.value = enemy.health
	enemy.health_bar.max_value = enemy.initial_health
	player.round_up.connect(next_round)


func _process(_delta: float) -> void:
	if ball.game_won and round_number >= 10 and not is_ended:
		end_game()
		is_ended = true
	
	player.health = clamp(player.health, 0.0, player.initial_health)

	if is_ended and ball.end_pop:
		ball.end_pop.queue_free()
	if is_ended and ball.win_pop:
		ball.win_pop.queue_free()
	
	manage_damage(player, enemy)
	manage_damage(enemy, player)
	manage_health(player)
	manage_health(enemy)
	

	
	
	




func next_round():
	round_number += 1
	if round_number > 10:
		end_game()
	else:

		#player
		if round_number <= 5 :
			player.initial_health += 10
		player.health = player.initial_health
		player.current_damage = player.initial_damage

		player.health_bar.max_value = player.initial_health
		player.health_bar.value = player.health


		#enemy - change the enemy into a new random one
		
		upgrade_enemy()
		enemy.health = enemy.initial_health
		enemy.current_damage = enemy.initial_damage
		enemy.is_dead = false
		enemy.health_bar.max_value = enemy.initial_health
		enemy.health_bar.value = enemy.health
		
		ball.game_won = false
		ball.shape.show()
		get_tree().paused = false

	
	round_label.text = "Round : %d / %d" %[round_number, max_rounds]


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
	elif  round_number < 5:
		amount = 1
		enemy.damage_mult = 0.2
	elif round_number <= 7:
		amount = 2
		enemy.damage_mult = 0.3
	elif round_number < 10 :
		amount = 3
		enemy.damage_mult = 0.4
	else :
		amount = 4
		enemy.damage_mult = 0.4
	
	add_enemy_upgrades(amount)

func randomize_enemy_health():
	if round_number <= 5 :
		enemy.initial_health = randi_range(clamp((round_number*10) - 15, 1, round_number*10), round_number*10)

	else :
		enemy.initial_health = randi_range(50, 150)

func add_enemy_upgrades(amount : int):
	var upgrades_folder = DirAccess.open("res://Resources/Enemy/Scenes/")
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
	var winscrn = load("res://Scenes/win_screen.tscn").instantiate()
	ui_container.add_child(winscrn)
	get_tree().paused = true



func manage_health(entity):
	entity.health_bar.value = move_toward(entity.health_bar.value, entity.health, 0.2*abs(entity.health_bar.value - entity.health))
	entity.health_lable.text = "%.1f" %entity.health
	entity.health = clamp(entity.health, 0.0, entity.initial_health)
	if entity.health <= 0.0 and !entity.is_dead:
		entity.death()
	
	if entity.health <= entity.initial_health/4:
		entity.health_lable.label_settings.font_color = lerp(entity.health_lable.label_settings.font_color, Color.RED, 0.1)
		entity.health_bar_sb.bg_color = lerp(entity.health_bar_sb.bg_color, Color.RED, 0.1)
	elif entity.health <= entity.initial_health/2:
		entity.health_lable.label_settings.font_color = lerp(entity.health_lable.label_settings.font_color, Color.YELLOW, 0.1)
		entity.health_bar_sb.bg_color = lerp(entity.health_bar_sb.bg_color, Color.YELLOW, 0.1)
	else: 
		entity.health_lable.label_settings.font_color = lerp(entity.health_lable.label_settings.font_color, Color.LIGHT_GREEN, 0.1)
		entity.health_bar_sb.bg_color = lerp(entity.health_bar_sb.bg_color, Color.LIGHT_GREEN, 0.1)




func manage_damage(entity, opponent):
	entity.damage_label.text = "%.2f" %move_toward(float(entity.damage_label.text), entity.current_damage, 0.5*abs(entity.current_damage-float(entity.damage_label.text)))
	if abs(entity.current_damage-float(entity.damage_label.text)) <= 0.05:
		entity.damage_label.text = "%.2f" %entity.current_damage
	if entity.current_damage > opponent.health:
		entity.damage_label.label_settings.font_color = lerp(entity.damage_label.label_settings.font_color, Color(1, 0.43, 0.73), 0.1)
		entity.dmg_lbl.label_settings.font_color = lerp(entity.dmg_lbl.label_settings.font_color, Color(1, 0.43, 0.73), 0.1)
	elif entity.current_damage > opponent.health/2:
		entity.damage_label.label_settings.font_color = lerp(entity.damage_label.label_settings.font_color, Color(0.85, 0.50, 1.0), 0.1)
		entity.dmg_lbl.label_settings.font_color = lerp(entity.dmg_lbl.label_settings.font_color, Color(0.85, 0.50, 1.0), 0.1)
	else:
		entity.damage_label.label_settings.font_color = lerp(entity.damage_label.label_settings.font_color, Color(0.53, 0.9, 1.0), 0.1)
		entity.dmg_lbl.label_settings.font_color = lerp(entity.dmg_lbl.label_settings.font_color, Color(0.53, 0.9, 1.0), 0.1)
