extends Spatial

signal update_ui(weapons)

var weapons: Array = []
var current_weapon: Spatial

func take(weapon: String):
	for wep in get_children():
		wep.set_visible(false)
		
		if wep.weapon_name == weapon:
			wep.set_visible(true)
			wep.use()
			current_weapon = wep

func can_add(weapon: String) -> bool:
	return not weapon in weapons


func add_weapon(weapon: String):
	weapons.append(weapon)
	
	emit_signal("update_ui", weapons)
	
	if current_weapon != null: return
	
	take(weapon)

func _input(event):
	if not event is InputEventKey: return
	if not event.pressed: return
	
	var button = event.as_text()
	
	if not button.is_valid_integer() or button == "0": return
	
	if int(button) > weapons.size(): return
	
	var weapon_name = weapons[int(button)-1]
	
	if current_weapon != null and current_weapon.weapon_name == weapon_name: return
	
	take(weapon_name)
