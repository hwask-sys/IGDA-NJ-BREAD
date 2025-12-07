extends Projectile

class_name Toothpick

func _enter_tree() -> void:
	var ani = get_node("AnimatedSprite2D")
	ani.play("spawn_in")

func hideit():
	get_node("Area2D").monitorable = false
	get_node("Area2D").monitoring = false
	
func comeback():
	get_node("Area2D").monitorable = true
	get_node("Area2D").monitoring = true
