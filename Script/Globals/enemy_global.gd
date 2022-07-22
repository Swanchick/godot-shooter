extends Node

var enemys = {
	"fly_monster": load("res://Prefabs/Enemy/FlyMonster.tscn"),
	"monster1": load("res://Prefabs/Enemy/Monster1.tscn")
}

var waves = {
	"fly_monster": 30,
	"monster1": 100
}

func get_random_monster() -> String:
	return waves.keys()[rand_range(0, waves.size())]

