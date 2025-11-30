extends CharacterBody2D

@export var health := 77
@onready var scene = get_parent()
var player

var attack_circle_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword circle.tscn")

func _ready() -> void:
	player = %Player
	await get_tree().create_timer(2.0).timeout
	attack_circle()

func damage(hp):
	health -= hp

func attack_circle():
	var attack = attack_circle_pattern.instantiate()
	attack.tracked = player
	add_child(attack)
