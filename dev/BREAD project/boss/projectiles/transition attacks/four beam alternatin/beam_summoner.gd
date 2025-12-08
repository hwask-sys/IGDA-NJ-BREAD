extends Node2D

@onready var beam = preload("res://dev/BREAD project/boss/projectiles/lightbeam/lightbeam.tscn")

func summon_beam():
	var instance = beam.instantiate()
	instance.width = 67
	add_child(instance)
