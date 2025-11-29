extends Node2D

var parent

var up_attack = preload("res://dev/BREAD project/player/sword/attack_directions/up_slash.tscn")
var down_attack = preload("res://dev/BREAD project/player/sword/attack_directions/down_slash.tscn")
var left_attack = preload("res://dev/BREAD project/player/sword/attack_directions/left_slash.tscn")
var right_attack = preload("res://dev/BREAD project/player/sword/attack_directions/right_slash.tscn")

var attackCD = false

signal attacked

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_input_2") and parent.actionable and !attackCD:
		var verticalIntensity = Input.get_axis("player_up", "player_down")
		var horizontalIntensity = Input.get_axis("player_left", "player_right")
		if Input.is_action_pressed("player_up") and abs(verticalIntensity) > parent.INPUT_THRESHOLD:
			up()
		elif Input.is_action_pressed("player_down") and not parent.is_on_floor() and abs(verticalIntensity) > parent.INPUT_THRESHOLD:
			down()
		elif Input.is_action_pressed("player_left") and abs(horizontalIntensity) > parent.INPUT_THRESHOLD:
			left()
		elif Input.is_action_pressed("player_right") and abs(horizontalIntensity) > parent.INPUT_THRESHOLD:
			right()
		else:
			if parent.sprite.flip_h == false:
				right()
			else:
				left()


func up():
	var atk = up_attack.instantiate()
	add_child(atk)
	attacked.emit()

func down():
	var atk = down_attack.instantiate()
	add_child(atk)
	attacked.emit()

func left():
	var atk = left_attack.instantiate()
	add_child(atk)
	attacked.emit()

func right():
	var atk = right_attack.instantiate()
	add_child(atk)
	attacked.emit()


func _on_timer_timeout() -> void:
	attackCD = false


func _on_attacked() -> void:
	attackCD = true
