extends BaseEnemy

var player: KinematicBody
var can_hit: bool = false

onready var animator = $AnimationPlayer

onready var raycast = $RayCast

func _ready():
	player = G.player
	animator.play("Run")

func _process(delta):
	if player == null: return
	
	raycast.look_at(player.global_transform.origin, Vector3.UP)
	
	if raycast.is_colliding():
		var p = raycast.get_collider()
		if p.is_in_group("player"):
			can_hit = true
	else:
		can_hit = false

func _on_Timer_timeout():
	player = G.player
	if player == null: return
	_move_to(player.global_transform.origin)


func _on_HitTimer_timeout():
	if not can_hit: return
	
	
	player.take_damage(_get_damage())
