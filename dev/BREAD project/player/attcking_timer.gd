extends Timer

signal started

func _on_knife_positions_attacked() -> void:
	start()
	started.emit()
