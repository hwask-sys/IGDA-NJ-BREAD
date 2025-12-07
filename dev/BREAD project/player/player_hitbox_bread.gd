@tool
extends PlayerHitbox

class_name PlayerHitboxBread

var invincibility = false

@onready var anim = get_parent().get_node("Sprite2D")

func _on_hitbox_entered(other: Area2D):
	#print("entered")
	## for i-frames
	if invincibility:
		return
	
	# Ignore hitboxes
	if other is EnemyHitbox or other is SwordHitbox:
		return
	
	var source = other.get_parent()
	if source.has_method("get_source_damage"):
		player_reference.damage(source.get_source_damage())
		iframes()
	#else:
		#print_rich("[color=yellow]<WARNING: A potential damage source \"" + str(source.name) + 
		#"\" that does not have a get_source_damage() method has entered the PlayerSample hitbox>")

func iframes():
	anim.invulAnim()
	invincibility = true
	await get_tree().create_timer(1.2).timeout
	invincibility = false
	anim.invulAnimStop()

func fallenIFrames():
	anim.invulAnim()
	await get_tree().create_timer(5).timeout
	invincibility = false
	anim.invulAnimStop()
