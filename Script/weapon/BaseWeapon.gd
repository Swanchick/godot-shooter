extends Spatial
class_name BaseWeapon

var shoot_raycast: RayCast = get_parent()

var final_pos: Vector3 = Vector3.ZERO

export var weapon_name: String = "base"

export var weapon_sway: float = 5
export var weapon_accelaration: float = 0.1

export var max_range = 1
export var spread_distance: float = 10
export var start_rotation: Vector3 = Vector3.ZERO
export var start_pos: Vector3 = Vector3.ZERO

func _ready():
	start_pos = transform.origin
	shoot_raycast = get_parent().get_parent()
	start_rotation = shoot_raycast.rotation_degrees

func _get_direction(spread_disctance) -> Vector3:
	var dir = Vector3(
		rand_range(-spread_disctance, spread_disctance) + start_rotation.x,
		rand_range(-spread_disctance, spread_disctance) + start_rotation.y,
		start_rotation.z
	)
	
	return dir

func _input(event):
	if not event is InputEventMouseMotion: return
	
	final_pos = Vector3(
		event.relative.x * 0.001,
		0,
		event.relative.y * 0.001
	)

func _single_shoot():
	pass

func _shoot():
	pass


func _process(delta):
	if not is_visible_in_tree(): return
	
	transform.origin = transform.origin.linear_interpolate(start_pos - final_pos, weapon_sway * delta)
	
	if Input.is_action_pressed("fire"):
		_shoot()
	
	if Input.is_action_just_pressed("fire"):
		_single_shoot()
		
