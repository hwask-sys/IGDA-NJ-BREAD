extends Node2D

var tracked

func _process(_delta: float) -> void:
	global_position.y = tracked.global_position.y + 500
