extends PlayerSample
class_name BREAD_player

@export var mana = 0
var max_mana = 8

var healing_state = false

signal hud_update

var igothit = preload("res://dev/BREAD project/sfx/takedamage.ogg")
var igothit2 = preload("res://dev/BREAD project/sfx/death.ogg")

var dashsound = preload("res://DONOTEDITME/assets/sounds/sfx/jump.ogg")

var healsound = preload("res://dev/BREAD project/sfx/healsuccess.ogg")
var healstartsound = preload("res://dev/BREAD project/sfx/healwindup.ogg")

var jump_cancel = false
var dash_available = true
#i would have used enums but idk if you guys know how to use them
var dash_state = false
const DASHBUFFERTIME =.25
const DASHBUFFERTIME_MAX = .5
var dash_buffer = DASHBUFFERTIME
const DASHSPEEDMOD = 1.5
var stun = false

signal animateDash

#air drag for shmovement
const AIR_DRAG_WINDOW = 0.2
var air_drag_timer = 0
var air_drag = true

var actionable = true

var doFlip = true

func _physics_process(delta):
	
	if !air_drag:
		if is_on_floor():
			air_drag_timer = 0
		air_drag_timer -= delta
		if air_drag_timer <= 0:
			air_drag = true
			actionable = true
	
	
	#i have to separate here for the dash state
	if !dash_state and !stun and !healing_state:
		super(delta)
		
		if Input.is_action_just_released("player_jump") and jump_cancel and !can_jump() and velocity.y < -20 and actionable:
			velocity.y = -20
			jump_cancel = false
		
		if !jump_cancel and is_on_floor():
			jump_cancel = true
		
		if !dash_available and is_on_floor():
			dash_available = true
		
		if Input.is_action_just_pressed("player_jump") and !is_on_floor() and !jump_cancel and dash_available and actionable:
			dash_available = false
			airdash()
		
		if (Input.is_action_just_pressed("player_input_3") or Input.is_action_just_pressed("player_input_1"))and actionable and mana == max_mana:
			pass
			heal()
		
			
	else:
		dash_buffer -= delta
		velocity = Vector2(lerpf(velocity.x,0,10*delta),lerpf(velocity.y,0,10*delta))
		#for when the dash window opens
		if dash_buffer <= 0:
			var dir = Vector2(Input.get_axis("player_left", "player_right"), Input.get_axis("player_up", "player_down"))
			if abs(dir.x) >= INPUT_THRESHOLD:
				dir.x = sign(dir.x) * 1
			else:
				dir.x = 0
			
			if abs(dir.y) >= INPUT_THRESHOLD:
				dir.y = sign(dir.y) * 1
			else:
				dir.y = 0
			
			if dir != Vector2.ZERO and not healing_state:
				dash_state = false
				air_drag = false
				sound_player.play_sound_2d(dashsound, global_position)
				animateDash.emit(DASHBUFFERTIME)
				air_drag_timer = AIR_DRAG_WINDOW
				velocity = max_horizontal_speed * dir.normalized() * DASHSPEEDMOD
		
		else:
			animateDash.emit(dash_buffer)
		
		#for when the hover window ends
		if dash_buffer <= -DASHBUFFERTIME_MAX:
			dash_state = false
			animateDash.emit(DASHBUFFERTIME)
			velocity.x = 0
			actionable = true
		
		#i forgot to add this lol
		move_and_slide()

#sets the airdash state
func airdash():
	dash_buffer = DASHBUFFERTIME
	dash_state = true
	actionable = false

##similar healstate
func heal():
	mana = 0
	hud_update.emit(current_health, mana)
	healing_state = true
	sound_player.play_sound_2d(healstartsound, global_position)
	actionable = false
	$"%Heal Timer".start()

# modified for movement reasons
func move_horizontal(input: float, delta: float) -> void:
	if abs(input) < INPUT_THRESHOLD and abs(velocity.x) > 0:
		#velocity.x += -sign(velocity.x) * deceleration * delta
		velocity.x = lerpf(velocity.x,0,deceleration/60 * delta)
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD/10:
			velocity.x = 0
	elif abs(velocity.x) <= max_horizontal_speed:
		velocity.x += input * acceleration * delta
	if abs(velocity.x) > max_horizontal_speed and air_drag:
		##issue here
		velocity.x = lerpf(velocity.x,max_horizontal_speed * sign(velocity.x) ,deceleration/60 * delta)

func get_source_damage():
	return 0

# mainly readded for air drag mechanics
func apply_gravity(delta: float) -> void:
	if air_drag:
		# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
		if velocity.y < max_fall_speed:
			velocity.y += delta * gravity
			
			# Clamp the player's velocity to this lower bound
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed

func fall_damage():
	damage(1)
	get_node("PlayerHitboxBread").fallenIFrames()
	get_parent().blackscreen()
	actionable = false

func respawned():
	actionable = true

func update_animation() -> void:
	if (!is_on_floor()):
		anim_player.play("JUMP")
	else:
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD:
			anim_player.play("IDLE")
		else:
			anim_player.play("WALK")
			
	if doFlip:
		sprite.flip_h = true if sign(velocity.x) < 0 else (false if sign(velocity.x) > 0  else sprite.flip_h)

func recoil(dir):
	if dir == "left":
		velocity.x += 500
	if dir == "right":
		velocity.x -= 500
	if dir == "down":
		velocity.y = -450
		dash_available = true
	if dir == "up":
		if velocity.y < 0:
			velocity.y = 0
		else:
			velocity.y += 200

func get_mana():
	if mana < max_mana:
		mana += 1
		hud_update.emit(current_health, mana)

func damage(amount: float) -> void:
	sound_player.play_sound_2d(igothit, global_position)
	sound_player.play_sound_2d(igothit2, global_position)
	healing_state = false
	$"%Heal Timer".stop()
	sound_player.play_sound(hit_sound, global_position) # Assume when this is being called we are taking damage
	current_health -= amount
	current_health = clampf(current_health, 0, max_health)
	check_death()
	hud_update.emit(current_health, mana)
	

func _on_timer_started() -> void:
	doFlip = false

func _on_timer_timeout() -> void:
	doFlip = true

func _on_heal_timer_done_healing() -> void:
	if healing_state:
		dash_available = true
		current_health += 3
		if current_health > 8:
			current_health = 8
		sound_player.play_sound_2d(healsound, global_position)
		healing_state = false
		actionable = true
		hud_update.emit(current_health, mana)
