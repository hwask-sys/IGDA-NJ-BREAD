extends Node2D

var the_blade = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword lunge.tscn")

var tracked

var angel

var spawn = preload("res://dev/BREAD project/sfx/swordsummon.ogg")

func _enter_tree() -> void:
	angel.phase_over.connect(kys)
	var initial = (2 * PI / 8) 
#	mult by * randi_range(0,7)
	for k in range(3):
		var chosen = []
		
		var j = 4
		
		while j > 0:
			var temp = randi_range(0,7)
			if temp not in chosen:
				chosen.append(temp)
				j -= 1
		for i in chosen:
			var attack = the_blade.instantiate()
			attack.delay = .8
			attack.tracked = tracked
			attack.rotation = initial * i
			attack.mute()
			add_child(attack)
		sound_player.play_sound_2d(spawn, global_position)
		await get_tree().create_timer(1.0).timeout
	await get_tree().create_timer(20).timeout
	call_deferred("queue_free")

func _process(_delta: float) -> void:
	if tracked != null:
		global_position  = tracked.position

func kys():
	call_deferred("queue_free")
