extends EnemyUpgrade


var ball : Ball
var player : Player

func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	
	player.player_shot.connect(player_shot)



func enemy_shot():
	ball.shape.hide()
	ball.trail.modulate.a = 0.1
	

func player_shot():
	ball.shape.show()
	ball.trail.modulate.a = 1

func enemy_scored():
	ball.shape.show()
	ball.trail.modulate.a = 1
