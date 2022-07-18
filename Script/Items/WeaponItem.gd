extends Spatial

onready var weapon = $Weapon

export var weapon_class: String = "base"

var can_take = true

func _on_player_enter(player):
	if not player.is_in_group("player") or not can_take: return
	
	var inventory = player.inventory
	
	if not inventory.can_add(weapon_class): return
	
	weapon.queue_free()
	
	inventory.add_weapon(weapon_class)
