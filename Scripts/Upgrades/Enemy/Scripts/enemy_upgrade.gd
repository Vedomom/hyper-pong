extends Node
class_name EnemyUpgrade


@export var enemy : Enemy


func _ready() -> void:
	enemy = get_parent().get_parent()
	if enemy:
		initialize_power()
	enemy.enemy_shot.connect(enemy_shot)
	enemy.enemy_damaged.connect(enemy_damaged)
	enemy.enemy_scored.connect(enemy_scored)

func enemy_shot():
	pass


func initialize_power():
	pass

func enemy_damaged():
	pass

func enemy_scored():
	pass
