extends Node2D


func _on_rotating_beams_evens() -> void:
	for i in get_children():
		i.summon_beam()
