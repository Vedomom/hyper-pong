extends EnemyUpgrade

var ball : Ball
var player : Player
var mult 
var is_hard_hit := false

func initialize_power():
	titel = "HardHit"
	description = "Hits the ball hard"
	for node in enemy.get_parent().get_children():
		if node is Ball:
			ball = node
		if node is Player:
			player = node
	player.player_shot.connect(player_shot)
	mult = randf_range(1.5, 1.9)


func enemy_shot():
	if !is_hard_hit:
		HitStop.hit_stop(0.14)
		ball.speed += 100 * mult
		is_hard_hit = true

func player_shot():
	if is_hard_hit:
		ball.speed -= 100 * mult
		is_hard_hit = false

func enemy_scored():
	if is_hard_hit:
		ball.speed -= 100 * mult
		is_hard_hit = false
