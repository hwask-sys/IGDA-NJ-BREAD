extends CharacterBody2D

@export var health := 77
@onready var scene = get_parent()
var player


var rand_move_point = global_position
var move_speed = 400

var attack_circle_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword circle.tscn")
var attack_fourside_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/four angles.tscn")
var attack_lightrain_pattern = preload("res://dev/BREAD project/boss/projectiles/lightbeam patterns/lightrain.tscn")
var attack_lightspam_pattern = preload("res://dev/BREAD project/boss/projectiles/lightbeam patterns/lightspam.tscn")

enum {CIRCLE, FOURSIDE, LIGHTRAIN, LIGHTSPAM}

var lastAttack = 9

var beamcount = 3

var base_cooldown = 6

func _ready() -> void:
	rand_move_point = global_position
	player = %Player
	await get_tree().create_timer(2.0).timeout
	random_attack()
	$"%Movement Timer".start()

func damage(hp):
	health -= hp

func random_attack():
	var temp = randi_range(0,3)
	if temp == CIRCLE:
		attack_circle()
	elif temp == FOURSIDE:
		fourside()
	elif temp == LIGHTRAIN:
		lightrain()
	elif temp == LIGHTSPAM:
		lightspam()

func attack_circle():
	var attack = attack_circle_pattern.instantiate()
	attack.tracked = player
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func fourside():
	var attack = attack_fourside_pattern.instantiate()
	attack.tracked = player
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func lightrain():
	var attack = attack_lightrain_pattern.instantiate()
	attack.bounds = scene.bounds
	attack.tracked = player
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func lightspam():
	var attack = attack_lightspam_pattern.instantiate()
	attack.bounds = scene.bounds
	attack.tracked = player
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown * 1.5
	$"Attack Timer".start()

func _on_movement_timer_timeout() -> void:
	var rect = scene.bounds
	var x = randi_range(int(rect.global_position.x)-int(rect.shape.size.x/2), int(rect.global_position.x)+int(rect.shape.size.x/2))
	var y = randi_range(int(rect.global_position.y)-int(rect.shape.size.y/2), int(rect.global_position.y)+int(rect.shape.size.y/2))
	rand_move_point = Vector2(x,y)

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(rand_move_point)
	if global_position.distance_to(rand_move_point) > 10:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
		if $"%Movement Timer".is_stopped():
			$"%Movement Timer".start()
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	random_attack()
