extends CharacterBody2D

signal revealed
signal hit

func damage(_meh):
	print("ow")
	get_node("Sprite2D").modulate = Color(10,10,10,10)
	get_parent().get_parent().get_parent().respawn_angel(global_position)
	hit.emit()


func _on_timer_timeout() -> void:
	visible = true
	var temp = get_node("EnemyHitbox_BREAD")
	temp.monitoring = true
	temp.monitorable = true
	revealed.emit()
