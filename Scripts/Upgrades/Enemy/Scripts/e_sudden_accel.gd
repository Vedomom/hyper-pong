extends EnemyUpgrade

var ball : Ball
var prev_speed


func initialize_power():
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
	prev_speed = ball.speed



func enemy_shot():

	prev_speed = ball.speed
	ball.speed = ball.initial_speed * 0.5
	await get_tree().create_timer(1.5).timeout
	ball.speed = prev_speed
	ball.direction.y *= sign(randi_range(-10, 10))
	ball.curve *= sign(randf_range(-10, 10))
