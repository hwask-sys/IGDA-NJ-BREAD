extends Node2D

var fadeout = false
var fadein = true

var predicted = 0.0

signal okok

func _enter_tree() -> void:
	for i in get_children():
		i.hideit()

func _process(delta: float) -> void:
	rotation += delta * 2
	
	if fadein:
		predicted += delta / 1.5
		print(predicted)
		modulate.a = predicted
		if modulate.a >= 1:
			fadein = false
			okok.emit()
	
	if fadeout:
		modulate.a -= delta
		if modulate.a <= 0:
			call_deferred("queue_free")


func _on_sleeping_eye_revealed() -> void:
	fadeout = true

func _on_rotating_swords_okok() -> void:
	for i in get_children():
		i.comeback()


func _on_okok() -> void:
	for i in get_children():
		i.comeback()
