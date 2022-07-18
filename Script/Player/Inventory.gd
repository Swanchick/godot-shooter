extends Spatial

var weapons: Array = []


func can_add(weapon: String) -> bool:
	return not weapon in weapons


func add_weapon(weapon: String):
	weapons.append(weapon)

func _input(event):
	var button = event.as_text()
	
	if not button.is_valid_integer(): return
	
	if int(button) > weapons.size(): return
	
	for wep in get_children():
		wep.set_visible(false)
		if wep.weapon_name == weapons[int(button)-1]:
			wep.set_visible(true)
			
