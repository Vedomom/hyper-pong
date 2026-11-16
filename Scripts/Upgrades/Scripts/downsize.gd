extends Upgrades

var ball 
var enemy
var is_downsized := false

func initialize_power():
	player.can_downsize = true
	for node in player.get_parent().get_children():
		if node is Ball or node is MultBall:
			ball = node
		if node != player and node is Player_1 or node is Player_2 or node is Enemy:
			enemy = node

	if enemy is Enemy:
		enemy.enemy_shot.connect(enemy_shot)
	else :
		enemy.player_shot.connect(enemy_shot)

func player_shot():
	if !is_downsized:
		ball.scale *= 0.5
		ball.trail.width *= 0.5
		ball.speed += 50
		is_downsized = true


func enemy_shot():
	if is_downsized:
		is_downsized = false
		ball.scale = Vector2(0.7, 0.7)
		ball.trail.width *= 2
		ball.speed -= 50
		
	

func player_scored():
	if is_downsized:
		is_downsized = false
		await get_tree().create_timer(0.03).timeout
		ball.scale = Vector2(0.7, 0.7)
		ball.trail.width *= 2
		ball.speed -= 50
		
