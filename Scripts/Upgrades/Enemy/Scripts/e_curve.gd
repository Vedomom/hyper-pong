extends EnemyUpgrade



func initialize_power():
	titel = "Curve"
	description = "can Curve the ball"
	enemy.curve_power = randf_range(0.4, 1)
