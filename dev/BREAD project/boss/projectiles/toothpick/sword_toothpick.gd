extends Projectile

class_name Toothpick

var spawn = preload("res://dev/BREAD project/sfx/swordsummon.ogg")

@export var muted = false

func _enter_tree() -> void:
	if not muted:
		sound_player.play_sound_2d(spawn, global_position)
	var ani = get_node("AnimatedSprite2D")
	ani.play("spawn_in")

func hideit():
	get_node("Area2D").monitorable = false
	get_node("Area2D").monitoring = false
	
func comeback():
	get_node("Area2D").monitorable = true
	get_node("Area2D").monitoring = true
