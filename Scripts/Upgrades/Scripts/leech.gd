extends Upgrades

func initialize_power():
	player.leech_power += 10.0


func player_scored():
	if player.current_damage > 0 and player.current_damage < player.leech_power:
		player.health += player.current_damage
	else :
		player.health += player.leech_power
