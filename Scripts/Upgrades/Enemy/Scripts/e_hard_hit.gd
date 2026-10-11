extends EnemyUpgrade

var ball : Ball
var prev_speed
var player : Player

func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	prev_speed = ball.speed
	player.player_shot.connect(player_shot)


func enemy_shot():
	var mult = randf_range(1.5, 2.5)
	prev_speed = ball.speed
	ball.speed = ball.initial_speed * mult

func player_shot():
	ball.speed = prev_speed

func enemy_scored():
	ball.speed = prev_speed
