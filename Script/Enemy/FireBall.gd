extends KinematicBody

export var speed: float = 250

func _ready():
	pass

func _physics_process(delta):
	var dir: Vector3 = -transform.basis.z
	
	move_and_slide(dir * speed * delta)


func destroy():
	queue_free()


func _on_player_enter(body):
	if not body.is_in_group("player"): return
	
	body.take_damage(50)
