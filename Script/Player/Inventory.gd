extends Spatial

var weapons: Array = []


func can_add(weapon: String) -> bool:
	return weapon in weapons


func add_weapon(weapon: String):
	weapons.append(weapon)

func _input(event):
	if event.as_text().is_valid_integer():
		print(event.as_text())
