extends Node

var player: KinematicBody
var inventory: Inventory
var GRAVITY: float = 20

func _process(delta):
	if Input.is_action_just_pressed("Close"):
		get_tree().quit()
