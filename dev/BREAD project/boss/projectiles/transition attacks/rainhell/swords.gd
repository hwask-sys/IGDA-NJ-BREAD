extends Node2D

@onready var tracked = get_parent().tracked

var the_blade = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword lunge.tscn")


func _on_swordtimer_timeout() -> void:
	var initial = (2 * PI / 8) * randi_range(0,7)
	var attack = the_blade.instantiate()
	attack.tracked = tracked
	attack.rotation = initial
	add_child(attack)
