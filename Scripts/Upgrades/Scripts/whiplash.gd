extends Upgrades

var ball : Ball


func initialize_power():
	for node in player.get_parent().get_children():
		if node is Ball:
			ball = node
	




func player_shot():
	var tm : float = 0
	var sleeptime = self.name.remove_chars("Whiplash").to_int()
	if sleeptime > 0:
		tm = sleeptime * 0.2
	await get_tree().create_timer(0.4 + tm).timeout
	print(self.name.remove_chars("Whiplash"))
	print(sleeptime)
	print(tm)
	ball.direction.y *= -1.0
	ball.curve_sign *= -1
