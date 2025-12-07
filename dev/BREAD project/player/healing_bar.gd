extends TextureProgressBar

@export var healingTime = 1.5
var healing = false
var healingDone = 0.0
signal doneHealing

func start():
	healingDone = 0
	value = 0
	healing = true

func stop():
	healing = false
	healingDone = 0
	value = 0

func _process(delta: float) -> void:
	if healing:
		healingDone += delta / healingTime * 100.0
		value = healingDone
		if value >= max_value:
			healingDone = 0
			healing = false
			value = 0
			doneHealing.emit()
