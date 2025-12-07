extends Area2D

func _on_hitbox_entered(area: Area2D) -> void:
	if  area is SwordHitbox:
		area.get_parent().knockback()

func _on_area_entered(area: Area2D) -> void:
	if  area is SwordHitbox:
		area.get_parent().knockback()
