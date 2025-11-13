extends PlayerSample
class_name BREAD_player

var jump_cancel = false

func _physics_process(delta):
	super(delta)
	
	if Input.is_action_just_released("player_jump") and jump_cancel and !can_jump() and velocity.y < -20:
		velocity.y = -20
		jump_cancel = false
	
	if !jump_cancel and is_on_floor():
		jump_cancel = true
