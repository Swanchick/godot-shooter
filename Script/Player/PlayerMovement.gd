extends KinematicBody

var direction = Vector3()
var movement = Vector3()
var a_velocity = Vector3()
var g_velocity = Vector3()
var full_connected: bool = false
var acceleration: float = 0
var can_do_jump: bool = false
var can_shake: bool = false

onready var inventory = $Head/Camera/RayCast/Inventory

export var speed = 5.0
export var air_acceleration = 2
export var floor_acceleration  = 10
export var jump_force: float = 5
export var strafe_speed: float = 10
export var health: float = 100

export var mouse_sensetivity = 0.1

onready var head = $Head
onready var camera = $Head/Camera
onready var ground_check: RayCast = $GroundCheck
onready var health_label = $Health
onready var animator = $AnimationPlayer

var camera_start_pos: Vector3
var GRAVITY = G.GRAVITY

var shake_end_time: float = 0
var shake_time: float = 0
var shake: bool = false
var shake_impulse: float = 0
var shake_speed: float = 4

func _ready():
	camera_start_pos = camera.rotation_degrees
	G.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if not event is InputEventMouseMotion: return
	
	rotate_y(deg2rad(-event.relative.x * mouse_sensetivity))
	head.rotate_x(deg2rad(-event.relative.y * mouse_sensetivity))
	head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _kill():
	get_tree().quit()

func take_damage(damage: float):
	health -= damage
	
	if health <= 0:
		_kill()

func start_shake(impulse: float, time: float, speed: float):
	if shake: return
	
	shake_impulse = impulse
	shake_end_time = time
	shake_speed = speed
	shake = true

func _shake(delta):
	if not shake: 
		camera.rotation_degrees = camera.rotation_degrees.linear_interpolate(camera_start_pos, delta * shake_speed)
		return
	
	if shake_time >= shake_end_time: 
		shake = false
		shake_time = 0
		return
	
	shake_time += delta
	
	var rot = Vector3(
		rand_range(-shake_impulse, shake_impulse),
		rand_range(-shake_impulse, shake_impulse),
		0
	)
	
	camera.rotation_degrees = camera.rotation_degrees.linear_interpolate(rot, delta * shake_speed)

func _process(delta):
	health_label.text = "HP " + str(round(health))

func _physics_process(delta):
	_shake(delta)
	
	direction = Vector3.ZERO
	
	full_connected = ground_check.is_colliding()
	
	if not is_on_floor():
		g_velocity += GRAVITY * Vector3.DOWN * delta
		acceleration = air_acceleration
	elif is_on_floor() and full_connected:
		g_velocity = -get_floor_normal()
		can_do_jump = true
		acceleration = floor_acceleration
	else:
		acceleration = floor_acceleration
		g_velocity.y = 0
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or full_connected):
		g_velocity = sqrt(jump_force * 2 * GRAVITY) * Vector3.UP
		#g_velocity = jump_force * Vector3.UP
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and can_do_jump:
		g_velocity = sqrt(jump_force * 2 * GRAVITY) * Vector3.UP
		can_do_jump = false
	
	if Input.is_action_just_pressed("Strafe"):
		start_shake(4, 0.1, 20)
	
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
	
	
	if bool(direction.length()) and is_on_floor():
		if not animator.is_playing():
			animator.play("Run")
	else:
		animator.play("RESET")
	
	move_and_slide(movement, Vector3.UP)
