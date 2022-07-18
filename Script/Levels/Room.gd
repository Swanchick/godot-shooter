extends Spatial

onready var anchor = $Anchor
onready var anchor1 = $Anchor1

func _on_player_enter(body):
	if not body.is_in_group("player"): return
	
	# Change player rotation
	
	var rot = anchor.rotation.y - body.rotation.y
	
	body.rotation.y = -rot
	
	# Teleport player
	
	var player_pos = body.global_transform.origin
	
	var start_pos = anchor.global_transform.origin
	
	var pos = Vector3(
		player_pos.x - start_pos.x,
		player_pos.y,
		player_pos.z - start_pos.z
	)
	
	var end_pos = anchor1.global_transform.origin
	
	body.global_transform.origin = Vector3(
		end_pos.x + pos.z,
		player_pos.y,
		end_pos.z - pos.x
	)
	
	# Change player velocity
	
	var velocity = Vector3(
		body.a_velocity.z,
		body.a_velocity.y,
		-body.a_velocity.x
	)
	
	body.a_velocity = velocity
	
	
