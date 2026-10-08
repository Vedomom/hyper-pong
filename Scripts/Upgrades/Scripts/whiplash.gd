extends Upgrades

var ball : Ball

func initialize_power():
	for node in player.get_parent().get_children():
		if node is Ball:
			ball = node


func player_shot():
	await get_tree().create_timer(1).timeout
	ball.direction.y *= -1.0
