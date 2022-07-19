extends BaseWeapon

onready var animator = $AnimationPlayer

export (PackedScene) var sphere

func trace_bullets():
	for i in range(10):
		shoot_raycast.rotation_degrees = _get_direction(spread_distance)
		shoot_raycast.force_raycast_update()
		
		if shoot_raycast.is_colliding():
			var e = shoot_raycast.get_collider()
			
			if e != null and e.is_in_group("enemy"):
				e.take_damage(_get_damage())
			
			var point = shoot_raycast.get_collision_point()
			var s = sphere.instance()
			
			s.global_transform.origin = point
			
			get_tree().get_current_scene().add_child(s)
	
	shoot_raycast.rotation_degrees = start_rotation

func use():
	animator.play("Take")

func _shoot():
	if animator.is_playing(): return
	trace_bullets()
	animator.play("Shoot")
	
	
