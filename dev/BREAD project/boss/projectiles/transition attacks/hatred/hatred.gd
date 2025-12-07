extends Node2D

var bounds

var beam = preload("res://dev/BREAD project/boss/projectiles/lightbeam/infinite height.tscn")

var tracked

func _on_sleeping_eye_hit() -> void:
	call_deferred("queue_free")


func _on_sleeping_eye_revealed() -> void:
	for i in range(30):
		var x = randi_range(int(bounds.global_position.x)-int(bounds.shape.size.x/2), int(bounds.global_position.x)+int(bounds.shape.size.x/2))
		var instance = beam.instantiate()
		instance.global_position.x = x - 378
		instance.width = 100000000000
		instance.tracked = tracked
		instance.active = 200
		add_child(instance)
