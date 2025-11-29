extends Node2D

var the_blade = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword lunge.tscn")

var tracked

func _enter_tree() -> void:
	var initial = (2 * PI / 8) * randi_range(0,7)
	var choices = [-1, 1]
	var direction = choices[randi() % choices.size()]
	for i in range(0,8):
		var attack = the_blade.instantiate()
		attack.tracked = tracked
		attack.rotation = initial + ((2 * PI / 8) * direction * i)
		add_child(attack)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(30).timeout
	call_deferred("queue_free")
