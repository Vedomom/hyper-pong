extends Upgrades

var ball : CharacterBody2D


func initialize_power():
	for node in player.get_parent().get_children():
		if node is Ball or node is MultBall:
			ball = node

	




func player_shot():
	var tm : float = 0
	var sleeptime = self.name.remove_chars("Whiplash").to_int()
	if sleeptime > 0:
		tm = sleeptime * 0.2
	await get_tree().create_timer(0.4 + tm).timeout
	ball.direction.y *= -1.0
	ball.curve_sign *= -1
