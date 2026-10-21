extends EnemyUpgrade


func initialize_power():
	enemy.curve_power = randf_range(0.4, 1)
