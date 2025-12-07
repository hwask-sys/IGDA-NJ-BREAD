extends Node2D

signal evens
signal odds

const DELAY = 2.1

func _enter_tree() -> void:
	await get_tree().create_timer(3).timeout
	evens.emit()

func _process(delta: float) -> void:
	rotation -= delta * 0.9
	

func _on_evens() -> void:
	await get_tree().create_timer(DELAY).timeout
	odds.emit()

func _on_odds() -> void:
	await get_tree().create_timer(DELAY).timeout
	evens.emit()
