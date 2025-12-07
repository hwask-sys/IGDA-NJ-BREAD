extends Sprite2D

var dark = false
var bright = false

func _on_test_environment_darken() -> void:
	dark = true

func _on_test_environment_brighten() -> void:
	bright = true

func _process(delta: float) -> void:
	if dark:
		modulate.a += delta
		if modulate.a >= .5:
			dark = false
	elif bright:
		modulate.a -= delta
		if modulate.a <= 0.0:
			bright = false
