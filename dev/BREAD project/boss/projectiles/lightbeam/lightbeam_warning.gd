extends Sprite2D

var final_scale
var warn_active = false
var warn_fading = false

func warn(width):
	modulate.a = 0.5
	scale.y = 0.1
	final_scale = width/100.0
	visible = true
	warn_active = true
	
func _process(delta: float) -> void:
	if warn_active:
		var predicted = scale.y + 4 * delta
		if predicted < final_scale:
			scale.y = predicted
		else:
			scale.y = final_scale
			warn_active = false
			warn_fading = true
	if warn_fading:
		if modulate.a > 0:
			modulate.a -= delta * 1
