extends CharacterBody2D
## This PlayerLegacy class represents the basic player controller and builds off of 
## CharacterBody2D functionality. This class provides a variety of methods for you to be
## able to extend and override if you wanted to modify the player's functionality, as well as
## several quantities for you to tweak to change the feel of the player controller.
## DO NOT modify this script. Instead you should create a new script that extends the PlayerLegacy class
## if you want to create custom player functionality.
class_name PlayerSample

## This quantity represents the threshold by which input is considered to be 0
const INPUT_THRESHOLD: float = 0.01
## This quantity represents the threshold for player speed under which player speed is considered to be 0
const STOP_VELOCITY_THRSHOLD: float = 0.01

@export_category("Movement Config")
## This quantity represents the player's maximum horizontal speed in pixels/sec
@export var max_horizontal_speed: float = 50
## The acceleration constant is used to speed the player up to their maximum speed, and this quantity
## is given in pixels/sec^2.
@export var acceleration: float = 500
## The deceleration constant is used to slow the player down when there is no player input. I give this
## a separate variable in case you want the player to slow down faster than they speed up for more precise
## movement. You can always set this quantity to be the same as the acceleration constant if not.
@export var deceleration: float = 1000
## When jumping the player's y-velocity is set to this amount (units in pixels/sec). Using kinematics
## you can about approximate the player's max jump height to be equal to this quantity in pixels
## (assuming the gravitational constant is fixed to 9.8 pixels/sec^2)
@export var jump_strength: float = 20
## This is the player's gravitational constant in pixels/sec^2. The player will constantly be experiencing
## this downward acceleration when they are not grounded (default behavior). You can increase this 
## constant to increase the magnitude of the player's downward acceleration (make the player heavier).
@export var gravity: float = 9.8
## This is the player's maximum fall speed, and will be used the clamp the player's negative velocity
## so that they don't accelerate past this speed while in freefall
@export var max_fall_speed: float = 50

@export_category("Health/Damage Config")
## The maximum health of the player
@export var max_health: float = 1
## The starting health of the player
@export var starting_health: float = 1
## The contact damage that the player deals
@export var contact_damage: float = 1

## NOTE: YOU DO NOT HAVE TO USE ANY OF THESE SOUNDS, THIS IS JUST FOR DEFAULT BEHAVIOR
@export_category("Default Sound Config")
## The sound clip to be played when the player is walking
@export var footstep_sound: AudioStream
## The time between footsteps
@export var footstep_max_time: float = 0.1
## The jump sound effect
@export var jump_sound: AudioStream
## The hit sound effect
@export var hit_sound: AudioStream

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

# PlayerLegacy State
var current_health: float
var footstep_time: float

## This method is called on the first frame that the PlayerLegacy is active in the scene tree, and by default
## does not do anything. Feel free to override this method if you need to execute any code on the first
## frame.
func _ready():
	current_health = starting_health
	footstep_time = footstep_max_time


## This method is called every frame of the game (separate from _physics_process) and by default does not
## do anything. Feel free to overrice this method if you need to execute any code every frame separate from
## the physics engine.
func _process(_delta):
	pass


## This method is called every update of the Godot physics engine, so all physics adjacent computations
## and function calls should be done in this method. You are free to override this function and develop
## your own implementation of player control and movement if you want.
func _physics_process(delta):
	# Retrieve the horizontal input axis
	var direction = Input.get_axis("player_left", "player_right")
	
	# Set the player's horizontal velocity based on player input
	move_horizontal(direction, delta)
	if (direction != 0 and footstep_time < 0 and is_on_floor()):
		footstep_time = footstep_max_time
		sound_player.play_sound(footstep_sound, global_position)
	else:
		footstep_time -= delta
	
	# Check if the player can jump and execute the jump function if so
	if Input.is_action_just_pressed("player_jump") and can_jump():
		sound_player.play_sound(jump_sound, global_position)
		jump()
	
	# Apply gravity if the player is not grounded
	if !is_on_floor():
		apply_gravity(delta)
	
	# Update the player's animation
	update_animation()
	
	# Call this function to move the player based on all modifications to the player's velocity
	move_and_slide()


## Takes a horizontal input value and calculates player horizontal movement accordingly. This 
## function automatically handles acceleration and deceleration of the player when there is/isn't
## user input respectively
func move_horizontal(input: float, delta: float) -> void:
	if abs(input) < INPUT_THRESHOLD and abs(velocity.x) > 0:
		velocity.x += -sign(velocity.x) * deceleration * delta
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD:
			velocity.x = 0
	elif abs(velocity.x) < max_horizontal_speed:
		velocity.x += input * acceleration * delta
		if abs(velocity.x) > max_horizontal_speed:
			velocity.x = sign(input) * max_horizontal_speed


## Call this function to execute a jump. By default this function sets the player's vertical velocity
## to the jump_strength value to simulate an upward impulse
func jump() -> void:
	velocity.y = -jump_strength


## This function is called to both apply the gravitational acceleration to the player and clamp the 
## player's gravitational acceleration to their maximum fall speed.
func apply_gravity(delta: float) -> void:
	# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
	if velocity.y < max_fall_speed:
		velocity.y += delta * gravity
		
		# Clamp the player's velocity to this lower bound
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed


## This function is called to check if the player is able to jump. By default this is true if the 
## player is grounded, but this function can be overridden to give the player controller unique jump
## behavior without modifying the player's _process function. For example, double jumping can be implemented
## by allowing the player to jump once in the air. A counter can be used to track how many times
## the player has jumped while not grounded, and this can return true when that counter is 0 (or some
## other arbitrary value depending on how many jumps the player is allowed before needing to land).
func can_jump() -> bool:
	return is_on_floor()


## The default damage method for the player. Simply subtracts the amount from the
## player's current health.
func damage(amount: float) -> void:
	sound_player.play_sound(hit_sound, global_position) # Assume when this is being called we are taking damage
	current_health -= amount
	current_health = clampf(current_health, 0, max_health)
	check_death()


## The function that is called to check if the player has died and perform the correct
## functionality
func check_death() -> void:
	if current_health <= 0.0:
		print_rich("[color=pink]PlayerLegacy has died")
		level_loader.reload_level()


## This function is given to the player under the assumption that the player can deal
## contact damage to the enemies somehow (i.e. jumping on the enemy).
func get_source_damage() -> float:
	sound_player.play_sound(hit_sound, global_position) # Assume when this is being called we are dealing damage
	return contact_damage


## Updates the animation state of the player.
func update_animation() -> void:
	if (!is_on_floor()):
		anim_player.play("JUMP")
	else:
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD:
			anim_player.play("IDLE")
		else:
			anim_player.play("WALK")
			
	sprite.flip_h = true if sign(velocity.x) < 0 else (false if sign(velocity.x) > 0  else sprite.flip_h)
