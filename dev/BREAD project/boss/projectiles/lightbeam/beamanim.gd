extends AnimatedSprite2D

#because it needs a damage thing

func get_source_damage():
	return get_parent().get_source_damage()
