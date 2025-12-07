extends Area2D

class_name SwordHitbox

func _enter_tree() -> void:
	for i in get_overlapping_areas():
		if i.has_method("_on_hitbox_entered"):
			i._on_hitbox_entered(self)
		if i.get_parent() is Toothpick:
			get_parent().knockback()
