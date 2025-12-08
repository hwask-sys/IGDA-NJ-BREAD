extends Node2D

var tracked

var active = 1 

var width = 100

func mute():
	$Lightbeam.muted = true

func _enter_tree() -> void:
	$Lightbeam.width = width
	$Lightbeam.active = active
	
func _process(_delta: float) -> void:
	global_position.y = tracked.global_position.y + 500
