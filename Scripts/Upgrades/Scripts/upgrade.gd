extends Node
class_name Upgrades


@export var player : Player


func _ready() -> void:
	player = get_parent().get_parent()
	if player:
		initialize_power()
	player.player_shot.connect(player_shot)
	player.player_damaged.connect(player_damaged)
	player.player_scored.connect(player_scored)

func player_shot():
	pass


func initialize_power():
	pass

func player_damaged():
	pass

func player_scored():
	pass
