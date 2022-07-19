extends KinematicBody

var direction = Vector3()
var movement = Vector3()
var a_velocity = Vector3()
var g_velocity = Vector3()
var full_connected: bool = false

var can_do_jump: bool = false

onready var inventory = $Head/Camera/RayCast/Inventory

export var speed = 5.0
export var acceleration  = 10
export var jump_force: float = 5

export var mouse_sensetivity = 0.1

onready var head = $Head
onready var ground_check: RayCast = $GroundCheck

const GRAVITY = 20

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if not event is InputEventMouseMotion: return
	
	rotate_y(deg2rad(-event.relative.x * mouse_sensetivity))
	head.rotate_x(deg2rad(-event.relative.y * mouse_sensetivity))
	head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	direction = Vector3.ZERO
	
	full_connected = ground_check.is_colliding()
	
	if not is_on_floor():
		g_velocity += GRAVITY * Vector3.DOWN * delta
			
	elif is_on_floor() and full_connected:
		g_velocity = -get_floor_normal()
		can_do_jump = true
	else:
		g_velocity.y = 0
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or full_connected):
		g_velocity = sqrt(jump_force * 2 * GRAVITY) * Vector3.UP
		#g_velocity = jump_force * Vector3.UP
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and can_do_jump:
		g_velocity = sqrt(jump_force * 2 * GRAVITY) * Vector3.UP
		can_do_jump = false
	
	if is_on_ceiling() and not is_on_floor():
		g_velocity.y = 0
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	
	if Input.is_action_pressed("backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("right"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	
	direction = direction.normalized()
	a_velocity = a_velocity.linear_interpolate(direction * speed, acceleration * delta)
	movement.z = a_velocity.z
	movement.x = a_velocity.x
	movement.y = g_velocity.y
	
	move_and_slide(movement, Vector3.UP)
