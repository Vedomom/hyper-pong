extends EnemyUpgrade

var ball : Ball
var prev_speed


func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
	prev_speed = ball.initial_speed



func enemy_shot():

	prev_speed = ball.speed
	await get_tree().create_timer(0.5).timeout
	ball.speed = ball.initial_speed * 0.5
	await get_tree().create_timer(0.8).timeout
	ball.speed = prev_speed
	ball.direction.y *= sign(randi_range(-10, 10))
	ball.curve *= sign(randf_range(-10, 10))
