extends Node2D




func _on_sleeping_eye_hit() -> void:
	call_deferred("queue_free")
