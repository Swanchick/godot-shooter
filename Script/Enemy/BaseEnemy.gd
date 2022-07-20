extends KinematicBody
class_name BaseEnemy

var path = []
var path_node = 0
var velocity: Vector3 = Vector3.ZERO
var GRAVITY = G.GRAVITY
var g_vel: float = 0
var is_moving: bool = false

export var enemy_name: String = "base" 
export var health: float = 100
export var speed: float = 500
export var threshold = 2
export var rotation_speed: float = 5
export var damage: Vector2 = Vector2.ZERO


onready var nav: Navigation = get_parent()

func _kill():
	queue_free()

func _move_to(target_pos: Vector3):
	path_node = 0
	path = nav.get_simple_path(global_transform.origin, target_pos)

func take_damage(damage: float):
	health -= damage
	
	if health <= 0:
		_kill()

func _get_damage() -> float:
	var _damage: float = rand_range(damage.x, damage.y)
	
	return _damage

func _move(delta):
	if path_node >= path.size():
		is_moving = false
		return
	
	if path.size() > 0: 
		if global_transform.origin.distance_to(path[path_node]) < threshold: 
			path_node += 1
		else:
			var direction: Vector3 = path[path_node] - global_transform.origin
			direction = direction.normalized()
			
			direction = Vector3(
				direction.x,
				0,
				direction.z
			)
			
			var pos = global_transform.looking_at(path[path_node], Vector3.UP)
			transform = transform.interpolate_with(pos, rotation_speed * delta)
			
			
			velocity = direction.normalized() * speed * delta
			is_moving = true
			move_and_slide(velocity, Vector3.UP)

func _physics_process(delta):
	_move(delta)
	
	if not is_on_floor():
		g_vel += GRAVITY
	else:
		g_vel = 0
		
	move_and_slide(Vector3.DOWN * g_vel, Vector3.UP)
