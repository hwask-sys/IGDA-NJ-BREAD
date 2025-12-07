extends Node2D

@onready var bounds = get_parent().bounds

var beam = preload("res://dev/BREAD project/boss/projectiles/lightbeam/infinite height.tscn")

@onready var tracked = get_parent().tracked

func _on_timer_timeout() -> void:
	var x = randi_range(int(bounds.global_position.x)-int(bounds.shape.size.x/2), int(bounds.global_position.x)+int(bounds.shape.size.x/2))
	var instance = beam.instantiate()
	instance.global_position.x = x - 378
	instance.width = randi_range(50, 150)
	instance.tracked = tracked
	instance.active = 0.5
	add_child(instance)
