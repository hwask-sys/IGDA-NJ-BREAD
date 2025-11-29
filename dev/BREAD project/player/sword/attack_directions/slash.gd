extends Node2D

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	call_deferred("queue_free")
