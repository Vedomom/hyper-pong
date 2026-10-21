extends EnemyUpgrade

var ball : Ball
var prev_speed
var player : Player
var mult 

func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	prev_speed = ball.initial_speed
	player.player_shot.connect(player_shot)
	mult = randf_range(1.5, 1.9)


func enemy_shot():
	
	prev_speed = ball.speed
	ball.speed = ball.initial_speed * mult

func player_shot():
	ball.speed = prev_speed

func enemy_scored():
	ball.speed = prev_speed
