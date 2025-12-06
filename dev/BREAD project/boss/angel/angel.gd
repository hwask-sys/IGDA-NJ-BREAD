extends CharacterBody2D

@export var health := 77
@onready var scene = get_parent()
var player


var rand_move_point = global_position
var move_speed = 400

var attack_circle_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword circle.tscn")
var attack_lightrain_pattern = preload("res://dev/BREAD project/boss/projectiles/lightbeam patterns/lightrain.tscn")

var beamcount = 3

func _ready() -> void:
	rand_move_point = global_position
	player = %Player
	await get_tree().create_timer(2.0).timeout
	attack_circle()
	$"%Movement Timer".start()

func damage(hp):
	health -= hp

func attack_circle():
	var attack = attack_circle_pattern.instantiate()
	attack.tracked = player
	add_sibling(attack)

func lightrain():
	var attack = attack_lightrain_pattern.instantiate()
	attack.bounds = scene.bounds
	attack.tracked = player
	add_sibling(attack)

func _on_movement_timer_timeout() -> void:
	var rect = scene.bounds
	var x = randi_range(int(rect.global_position.x)-int(rect.shape.size.x/2), int(rect.global_position.x)+int(rect.shape.size.x/2))
	var y = randi_range(int(rect.global_position.y)-int(rect.shape.size.y/2), int(rect.global_position.y)+int(rect.shape.size.y/2))
	rand_move_point = Vector2(x,y)
	print(rand_move_point)

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(rand_move_point)
	if global_position.distance_to(rand_move_point) > 10:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
		if $"%Movement Timer".is_stopped():
			$"%Movement Timer".start()
	move_and_slide()
