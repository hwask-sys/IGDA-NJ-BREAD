extends AnimatedSprite2D


func _on_enemy_contact_hitbox_hit() -> void:
	modulate = Color(10,10,10,10)

func _on_flashtimer_timeout() -> void:
	modulate = Color(1,1,1,1)
