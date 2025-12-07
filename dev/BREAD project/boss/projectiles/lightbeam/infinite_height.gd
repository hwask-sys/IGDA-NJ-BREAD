extends Node2D

var tracked

var active = 1 

func _enter_tree() -> void:
	$Lightbeam.active = active

func _process(_delta: float) -> void:
	global_position.y = tracked.global_position.y + 500
