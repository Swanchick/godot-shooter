extends Control


onready var text_inventory = $Label



func _on_Inventory_update_ui(weapons):
	var out: String = ""
	
	for i in range(weapons.size()):
		out += str(i+1) + " " + weapons[i] + "\n"
	
	text_inventory.text = out
