extends Projectile

class_name Lightbeam

var muted = false

@export var width = 100
@export var active = 1.0
@export var rotation_from_horizontal = 0

@onready var final_scale = width/100.0
var warn_active = false
var warn_fading = false

func _enter_tree() -> void:
	rotation = rotation_from_horizontal * PI / 2
	$%beamanim.scale.y = 0.1
	$%warning.warn(width)
	await get_tree().create_timer(1.0).timeout
	warn_active = true
	$%CollisionShape2D.disabled = false
	$%beamanim.visible = true
	
	
func _process(delta: float) -> void:
	if warn_active:
		var predicted = $%beamanim.scale.y + 10 * delta
		if predicted < final_scale:
			$%beamanim.scale.y = predicted
		else:
			$%beamanim.scale.y = final_scale
			warn_active = false
			await get_tree().create_timer(active).timeout
			$%CollisionShape2D.disabled = true
			warn_fading = true
	if warn_fading:
		if $%beamanim.modulate.a > 0:
			$%beamanim.modulate.a -= delta * 3
		else:
			await get_tree().create_timer(5.0).timeout
			call_deferred("queue_free")
