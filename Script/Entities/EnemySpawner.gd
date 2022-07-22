extends Path

var count: int = 0

onready var path_folow = $PathFollow

export (PackedScene) var monster
export var max_spawns = 200

export var can_work = true

var current_wave = E.waves

func _spawn_monsters():
	if not can_work: return
	
	path_folow.unit_offset = randf()
	
	var m = E.get_random_monster()
	
	if current_wave[m] == 0: return
	
	current_wave[m] -= 1
	
	var _m = E.enemys[m].instance()
	_m.global_transform.origin = path_folow.global_transform.origin
	
	get_tree().get_current_scene().get_node("./Navigation").add_child(_m)
