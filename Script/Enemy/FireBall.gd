extends KinematicBody

var damage: Vector2

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
	
	body.take_damage(rand_range(damage.x, damage.y))
	body.start_shake(10, 0.1, 20)
