extends Node2D

var bounds 

var tracked

func _on_sleeping_eye_hit() -> void:
	call_deferred("queue_free")
