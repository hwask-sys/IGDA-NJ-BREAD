extends ColorRect

var fading_in = false 
var fading_out = false

func fade():
	fading_in = true 

func _process(delta: float) -> void:
	if fading_in:
		color.a += delta * 2.0
		if color.a >= 1.0:
			fading_in = false
			delay_thing()
	elif fading_out:
		color.a -= delta * 2.0
		if color.a <= 0.0:
			fading_out = false

func delay_thing():
	await get_tree().create_timer(1.0).timeout
	fading_out = true
