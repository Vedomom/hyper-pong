extends EnemyUpgrade

var ball : Ball

func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node


func enemy_shot():
	await get_tree().create_timer(randf_range(0.5, 1)).timeout
	ball.direction.y *= -1.0
	ball.curve_sign *= -1
