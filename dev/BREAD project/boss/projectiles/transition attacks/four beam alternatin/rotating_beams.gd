extends Node2D

signal evens
signal odds

const DELAY = 2.1

var lighting = preload("res://dev/BREAD project/sfx/beam.ogg")

func _enter_tree() -> void:
	await get_tree().create_timer(3).timeout
	evens.emit()

func _process(delta: float) -> void:
	rotation -= delta * 0.9
	

func _on_evens() -> void:
	await get_tree().create_timer(DELAY).timeout
	sound_player.play_sound_2d(lighting, global_position)
	odds.emit()

func _on_odds() -> void:
	await get_tree().create_timer(DELAY).timeout
	sound_player.play_sound_2d(lighting, global_position)
	evens.emit()
