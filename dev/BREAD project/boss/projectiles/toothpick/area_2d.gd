extends Area2D

var hit = preload("res://dev/BREAD project/sfx/metalhit.ogg")

func _on_hitbox_entered(area: Area2D) -> void:
	if  area is SwordHitbox:
		area.get_parent().knockback()

func _on_area_entered(area: Area2D) -> void:
	if  area is SwordHitbox:
		sound_player.play_sound_2d(hit, global_position)
		area.get_parent().knockback()
