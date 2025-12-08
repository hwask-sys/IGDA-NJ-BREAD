extends Node2D

var beam = preload("res://dev/BREAD project/boss/projectiles/lightbeam/infinite height.tscn")

var lighting = preload("res://dev/BREAD project/sfx/beam.ogg")

var tracked
var bounds 
var beam_count = 3
var beam_loops = 3

var initial_position

var angel

func _enter_tree() -> void:
	angel.phase_over.connect(kys)
	var rect = bounds
	
	for j in beam_loops:
		sound_player.play_sound_2d(lighting, global_position)
		for i in beam_count:
			var x = randi_range(int(rect.global_position.x)-int(rect.shape.size.x/2), int(rect.global_position.x)+int(rect.shape.size.x/2))
			#print("from " + str(int(bounds.global_position.x)-int(bounds.shape.size.x/2)) + " to " + str(int(bounds.global_position.x)+int(bounds.shape.size.x/2)))
			var instance = beam.instantiate()
			instance.global_position.x = x
			instance.tracked = tracked
			instance.mute()
			add_child(instance)
		await get_tree().create_timer(2.0).timeout
	
	await get_tree().create_timer(30.0).timeout
	call_deferred("queue_free")

func kys():
	call_deferred("queue_free")
