extends KinematicBody

export var health: float = 100

func _kill():
	queue_free()

func take_damage(damage: float):
	health -= damage
	
	if health <= 0:
		_kill()
