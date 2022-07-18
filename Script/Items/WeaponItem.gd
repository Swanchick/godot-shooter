extends Spatial

func _on_player_enter(player):
	if not player.is_in_group("player"): return
	
	var inventory = player.inventory
	print(inventory.test)
