extends EnemyUpgrade


var ball : Ball
var prev_color 
var prev_trail
var player : Player

func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	
	player.player_shot.connect(player_shot)
	prev_color = ball.modulate
	prev_trail = ball.trail.modulate


func enemy_shot():
	ball.modulate = Color.TRANSPARENT
	ball.trail.modulate = Color(1, 1, 1, 0.1)
	

func player_shot():
	ball.modulate = prev_color
	ball.trail.modulate = prev_trail

func enemy_scored():
	ball.modulate = prev_color
	ball.trail.modulate = prev_trail
