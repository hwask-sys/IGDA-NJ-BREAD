extends PlayerSample
class_name BREAD_player

var jump_cancel = false
var dash_available = true
#i would have used enums but idk if you guys know how to use them
var dash_state = false
const DASHBUFFERTIME =.25
const DASHBUFFERTIME_MAX = .5
var dash_buffer = DASHBUFFERTIME
const DASHSPEEDMOD = 1.5
var stun = false

#air drag for shmovement
const AIR_DRAG_WINDOW = 0.2
var air_drag_timer = 0
var air_drag = true

var actionable = true


func _physics_process(delta):
	
	if !air_drag:
		if is_on_floor():
			air_drag_timer = 0
		air_drag_timer -= delta
		if air_drag_timer <= 0:
			air_drag = true
			actionable = true
	
	
	#i have to separate here for the dash state
	if !dash_state and !stun:
		super(delta)
		
		if Input.is_action_just_released("player_jump") and jump_cancel and !can_jump() and velocity.y < -20:
			velocity.y = -20
			jump_cancel = false
		
		if !jump_cancel and is_on_floor():
			jump_cancel = true
		
		if !dash_available and is_on_floor():
			dash_available = true
		
		if Input.is_action_just_pressed("player_jump") and !is_on_floor() and !jump_cancel and dash_available:
			dash_available = false
			airdash()
			
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
			
			if dir != Vector2.ZERO:
				dash_state = false
				air_drag = false
				air_drag_timer = AIR_DRAG_WINDOW
				velocity = max_horizontal_speed * dir.normalized() * DASHSPEEDMOD
			
		#for when the hover window ends
		if dash_buffer <= -DASHBUFFERTIME_MAX:
			dash_state = false
			velocity.x = 0
			actionable = true
		
		#i forgot to add this lol
		move_and_slide()

#sets the airdash state
func airdash():
	dash_buffer = DASHBUFFERTIME
	dash_state = true
	actionable = false

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
		lerpf(velocity.x,max_horizontal_speed * sign(velocity.x) ,deceleration/60 * delta)

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
