extends Node2D

var fadeout = false

func _enter_tree() -> void:
	for i in get_children():
		i.hideit()
	await get_tree().create_timer(3).timeout
	for i in get_children():
		i.comeback()

func _process(delta: float) -> void:
	rotation += delta * 2
	
	if fadeout:
		modulate.a -= delta
		if modulate.a <= 0:
			call_deferred("queue_free")


func _on_sleeping_eye_revealed() -> void:
	fadeout = true
