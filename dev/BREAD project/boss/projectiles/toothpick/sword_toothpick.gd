extends Projectile

class_name Toothpick

func _enter_tree() -> void:
	var ani = get_node("AnimatedSprite2D")
	ani.play("spawn_in")
