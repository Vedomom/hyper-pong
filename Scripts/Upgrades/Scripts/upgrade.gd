extends Node
class_name Upgrades


@export var player : Player


func _ready() -> void:
	player = get_parent().get_parent()
	if player:
		initialize_power()
	player.player_shot.connect(player_shot)

func player_shot():
	pass


func initialize_power():
	pass
