extends Node2D

var tracking = true

var tracked

func _process(_delta: float) -> void:
	if tracking and tracked != null:
		position = tracked.position


func _on_rigid_body_2d_stop_tracking() -> void:
	tracking = false
