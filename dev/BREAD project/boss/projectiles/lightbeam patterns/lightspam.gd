extends Node2D

var beam = preload("res://dev/BREAD project/boss/projectiles/lightbeam/infinite height.tscn")

var tracked
var bounds 
var beam_count = 12

var initial_position

var angel

func _enter_tree() -> void:
	angel.phase_over.connect(kys)
	var rect = bounds
	
	for i in beam_count:
		var x = randi_range(int(rect.global_position.x)-int(rect.shape.size.x/2), int(rect.global_position.x)+int(rect.shape.size.x/2))
		var instance = beam.instantiate()
		instance.global_position.x = x
		
		instance.tracked = tracked
		instance.active = 0.5
		add_child(instance)
		await get_tree().create_timer(0.75).timeout
		
	
	await get_tree().create_timer(30.0).timeout
	call_deferred("queue_free")

func kys():
	call_deferred("queue_free")
