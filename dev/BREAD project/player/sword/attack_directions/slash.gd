extends Node2D

@export var knockback_determiner: String  

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	call_deferred("queue_free")

func knockback():
	self.get_parent().get_parent().recoil(knockback_determiner)

func get_mana():
	self.get_parent().get_parent().get_mana()
