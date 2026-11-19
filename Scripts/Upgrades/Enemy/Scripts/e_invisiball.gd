extends EnemyUpgrade


var ball : Ball
var player : Player
var is_invisiball := false

func initialize_power():
	titel = "Invisiball"
	description = "you can't see it"
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	
	player.player_shot.connect(player_shot)



func enemy_shot():
	if !is_invisiball:
		var twn = create_tween()
		twn.tween_method(shape_twn_mthd, 1.0, 0.0, 0.05)
		twn.tween_method(trail_twn_mthd, 1.0, 0.1, 0.05)
		is_invisiball = true

	

func player_shot():
	if is_invisiball:
		is_invisiball = false
		var twn = create_tween()
		twn.tween_method(shape_twn_mthd, 0.0, 1.0, 0.05)
		twn.tween_method(trail_twn_mthd, 0.1, 1.0, 0.05)


func enemy_scored():
	if is_invisiball:
		is_invisiball = false
		var twn = create_tween()
		twn.tween_method(shape_twn_mthd, 0.0, 1.0, 0.05)
		twn.tween_method(trail_twn_mthd, 0.1, 1.0, 0.05)


func shape_twn_mthd(value : float):
	ball.shape.modulate.a = value

func trail_twn_mthd(value : float):
	ball.trail.modulate.a = value
