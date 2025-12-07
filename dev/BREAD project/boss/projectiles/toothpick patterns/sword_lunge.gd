extends Node2D

var tracking = true

var tracked
var locked_position = Vector2.ZERO

var delay = 1.6

func mute():
	$%SwordToothpick.muted = true

func _enter_tree() -> void:
	global_position  = tracked.position
	visible = true

func _process(_delta: float) -> void:
	if tracking and tracked != null:
		global_position  = tracked.position
	else:
		global_position  = locked_position


func _on_rigid_body_2d_stop_tracking() -> void:
	tracking = false
	locked_position = global_position
