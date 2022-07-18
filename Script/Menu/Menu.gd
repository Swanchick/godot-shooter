extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _start_button():
	get_tree().change_scene("res://Levels/Room.tscn")


func _exit_button():
	pass # Replace with function body.
