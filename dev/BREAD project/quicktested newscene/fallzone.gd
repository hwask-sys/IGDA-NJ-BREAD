extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var source = area.get_parent()
	if source.has_method("fall_damage"):
		source.fall_damage()
