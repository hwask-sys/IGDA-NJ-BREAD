extends Sprite2D

var invul = false
var visible_timer = 0.01
var invisible_timer = 0.01


func _process(delta: float) -> void:
	if invul == true:
		if visible_timer > 0:
			visible_timer -= delta
			if visible_timer <= 0:
				visible = false
				invisible_timer = 0.1
		if invisible_timer > 0:
			invisible_timer -= delta
			if invisible_timer <= 0:
				visible = true
				visible_timer = 0.5

func invulAnim():
	invul = true

func invulAnimStop():
	invul = false
	visible = true
