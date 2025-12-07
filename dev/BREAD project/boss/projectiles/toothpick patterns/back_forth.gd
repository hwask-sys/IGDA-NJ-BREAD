extends CharacterBody2D

var moving = false
var going_forward = false
var parent_angle
signal stop_tracking
var tracking_timer = 0

func _enter_tree() -> void:
	await get_tree().create_timer(get_parent().delay).timeout
	moving = true
	parent_angle = get_parent().rotation
	velocity = Vector2(400 * cos(parent_angle),400 * sin(parent_angle))
	await get_tree().create_timer(10.0).timeout
	call_deferred("queue_free")

func _physics_process(delta: float) -> void:
	if moving:
		velocity -= Vector2(1000 * cos(parent_angle) * delta, 1000 * sin(parent_angle) * delta)
		if going_forward == false:
			tracking_timer += delta
			if tracking_timer > 0.42:
				going_forward = true
				stop_tracking.emit()
	move_and_slide()
