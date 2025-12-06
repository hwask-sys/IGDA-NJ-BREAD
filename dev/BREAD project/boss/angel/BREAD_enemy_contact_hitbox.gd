@tool
extends Area2D

## Im genuinely just stealing all the code bc im lazy

## Effectively the same logic as the player hitbox. Designed to detect player and player
## projectile hitboxes and interact with an enemy reference (the parent node). To support
## different enemy implementations all that I ask is that your enemy has a damage method for me
## to call when a player/player hurtbox projectile enters this hitbox.
class_name EnemyHitbox_BREAD

@onready var enemy_reference = $"../"

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_hitbox_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

'''
## This is the default hitbox detection behavior. It makes the assumption that the opposing hurtbox
## is a component/child of the object responsible for dealing damage to the enemy. It checks if that
## object has a get_source_damage() method and applies that damage to the enemy accordingly.
func _on_hitbox_entered(other: Area2D):
	# Ignore player hitboxes, player hitboxes should not cause damage
	if other is PlayerHitbox:
		return
	
	var source = other.get_parent()
	if source.has_method("get_source_damage"):
		enemy_reference.damage(source.get_source_damage())
	else:
		print_rich("[color=yellow]<WARNING: A potential damage source \"" + str(source.name) + 
		"\" that does not have a get_source_damage() method has entered the " + str(enemy_reference.name) + " hitbox>")
'''

##I actually commented that all out bc im lazy

func _on_hitbox_entered(other: Area2D):
	print(other)
	if other is SwordHitbox:
		enemy_reference.damage(1)
		other.get_parent().knockback()


## Extra code to show an editor warning if this is not attached to a PlayerSample object
func _get_configuration_warnings():
	if not (get_parent().has_method("damage")):
		return ["The parent of this EnemyHitbox component does not have a damage function"]
	
	return []
