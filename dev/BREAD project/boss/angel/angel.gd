extends CharacterBody2D

@export var health := 60
@onready var scene = get_parent()
var player

#self explanitory
@onready var ani = get_node("AnimatedSprite2D")
var fadein = false
var fadeout = false

var scratch = preload("res://dev/BREAD project/sfx/breadhit.ogg")
var scream = preload("res://dev/BREAD project/sfx/monstah.ogg")
var lightscream = preload("res://dev/BREAD project/sfx/lightscream.ogg")

var phase = 1
var invul = false
signal phase_over

var fadingawayforever = false
var imseriousendit = false

var rand_move_point = global_position
var move_speed = 400

var attack_circle_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/sword circle.tscn")
var attack_fourside_pattern = preload("res://dev/BREAD project/boss/projectiles/toothpick patterns/four angles.tscn")
var attack_lightrain_pattern = preload("res://dev/BREAD project/boss/projectiles/lightbeam patterns/lightrain.tscn")
var attack_lightspam_pattern = preload("res://dev/BREAD project/boss/projectiles/lightbeam patterns/lightspam.tscn")

enum {CIRCLE, FOURSIDE, LIGHTRAIN, LIGHTSPAM}

var side_phases = [preload("res://dev/BREAD project/boss/projectiles/transition attacks/four beam alternatin/four beam alternating.tscn"), preload("res://dev/BREAD project/boss/projectiles/transition attacks/rainhell/rainhell.tscn"), preload("res://dev/BREAD project/boss/projectiles/transition attacks/hatred/hatred.tscn")]


var lastAttack = 9
var lastLastAttack = 9

var beamcount = 3

## lowers to 5 eventually
var base_cooldown = 8

func _ready() -> void:
	rand_move_point = global_position
	player = %Player
	await get_tree().create_timer(2.0).timeout
	random_attack()
	$"%Movement Timer".start()

func damage(hp):
	if !invul:
		sound_player.play_sound_2d(scratch, global_position)
		health -= hp
		if health <= 0:
			if phase != 4:
				fadeout = true
			invul = true
			health = 60
			sound_player.play_sound_2d(scream, global_position)
			sound_player.play_sound_2d(lightscream, global_position)
			phase_over.emit()
			var temp = get_node("EnemyContactHitbox")
			temp.monitorable = false
			temp.monitoring = false
			
			
	

func random_attack():
	if !imseriousendit:
		var temp = randi_range(0,3)
		while temp == lastAttack and temp == lastLastAttack:
			temp = randi_range(0,3)
		lastLastAttack = lastAttack
		lastAttack = temp
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
	attack.angel = self
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func fourside():
	var attack = attack_fourside_pattern.instantiate()
	attack.tracked = player
	attack.angel = self
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func lightrain():
	var attack = attack_lightrain_pattern.instantiate()
	attack.bounds = scene.bounds
	attack.tracked = player
	attack.angel = self
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown
	$"Attack Timer".start()

func lightspam():
	var attack = attack_lightspam_pattern.instantiate()
	attack.bounds = scene.bounds
	attack.tracked = player
	attack.angel = self
	add_sibling(attack)
	$"Attack Timer".wait_time = base_cooldown * 1.5
	$"Attack Timer".start()

func _on_movement_timer_timeout() -> void:
	var rect = scene.bounds
	var x = randi_range(int(rect.global_position.x)-int(rect.shape.size.x/2), int(rect.global_position.x)+int(rect.shape.size.x/2))
	var y = randi_range(int(rect.global_position.y)-int(rect.shape.size.y/2), int(rect.global_position.y)+int(rect.shape.size.y/2))
	rand_move_point = Vector2(x,y)

func _physics_process(delta: float) -> void:
	
	if fadeout:
		ani.modulate.a -= delta * 2
		if ani.modulate.a <= 0:
			ani.modulate.a = 0
			fadeout = false
	elif fadein:
		ani.modulate.a += delta * 2
		if ani.modulate.a >= 1:
			ani.modulate.a = 1
			fadein = false
	elif fadingawayforever:
		ani.modulate.a -= delta
		if ani.modulate.a <= 0:
			fadingawayforever = false
			ani.modulate.a = 0
			true_end()
			imseriousendit = true
	elif imseriousendit:
		pass
	else:
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


func _on_phase_over() -> void:
	if phase == 4:
		end()
	else:
		phase_transition()

func waitComeBackINeedYou(gp):
	phase += 1
	sound_player.play_sound_2d(lightscream, global_position)
	cooldownUpdate()
	rand_move_point = gp
	global_position = gp
	fadein = true
	invul = false
	get_node("EnemyContactHitbox").invul = false
	$"Attack Timer".wait_time = base_cooldown / 2.0
	$"Movement Timer".wait_time = 4
	$"Movement Timer".start()
	$"Attack Timer".start()

func phase_transition():
	get_node("EnemyContactHitbox").invul = true
	var nextphase = side_phases[phase - 1]
	var temp = nextphase.instantiate()
	temp.tracked = player
	temp.bounds = scene.bounds
	temp.global_position = scene.respawn.global_position
	temp.global_position.y -= 100
	call_deferred("add_sibling",temp)
	

func cooldownUpdate():
	if phase != 4:
		base_cooldown = 7
	else:
		base_cooldown = 4
		health = 60

func end():
	imseriousendit = true
	$"Movement Timer".stop()
	$"Attack Timer".stop()
	await get_tree().create_timer(5.0).timeout
	fadingawayforever = true
	

func true_end():
	sound_player.play_sound_2d(lightscream, global_position)
	await get_tree().create_timer(5.0).timeout
	level_loader.end_level()
