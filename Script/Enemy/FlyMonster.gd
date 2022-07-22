extends BaseEnemy

onready var animator = $AnimationPlayer
onready var head = $Head

export var height_limit: float = 7
export var fly_speed: float = 10
export var shoot_threshold: float = 13
export (PackedScene) var fire_ball
export var accelaration: float = 10

var player: KinematicBody
var start_head_pos: Vector3 = Vector3.ZERO
var can_shoot: bool = false
var a_velocity: Vector3 = Vector3.ZERO

func _ready():
	animator.play("Fly")
	start_head_pos = head.transform.origin


func _gravity(delta):
	var y = global_transform.origin.y
	
	if y >= height_limit: return
	
	move_and_slide(Vector3.UP * fly_speed * delta, Vector3.UP)

func _move(delta):
	if global_transform.origin.distance_to(player.global_transform.origin) <= threshold: return
	
	var direction: Vector3 = -transform.basis.z
	
	a_velocity = a_velocity.linear_interpolate(direction.normalized() * speed, accelaration * delta)
	
	move_and_slide(a_velocity, Vector3.UP)

func _rotate_to(origin: Vector3, delta):
	origin = Vector3(
		origin.x,
		global_transform.origin.y,
		origin.z
	)
	
	var trans = global_transform.looking_at(origin, Vector3.UP)
	transform = transform.interpolate_with(trans, rotation_speed * delta)

func _process(delta):
	if player == null:
		player = G.player

func _head_rot(origin: Vector3):
	var trans = global_transform.looking_at(origin, Vector3.UP)
	trans.origin = start_head_pos
	
	head.transform = trans
	
	head.rotation = Vector3(
		head.rotation.x,
		0,
		0
	)

func _physics_process(delta):
	_gravity(delta)
	
	if player == null: return
	
	_head_rot(player.global_transform.origin)
	
	can_shoot = global_transform.origin.distance_to(player.global_transform.origin) <= shoot_threshold
	
	_move(delta)
	_rotate_to(player.global_transform.origin, delta)

func shoot():
	if not can_shoot: return
	if fire_ball == null: return
	
	var f: KinematicBody = fire_ball.instance()
	
	f.global_transform.origin = head.global_transform.origin
	
	var rot = Vector3(
		head.rotation.x,
		rotation.y,
		head.rotation.z
	)
	
	f.rotation = rot
	
	get_tree().get_current_scene().add_child(f)
