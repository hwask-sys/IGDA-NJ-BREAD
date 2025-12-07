extends CanvasLayer

@onready var blackscreen = get_node("BlackScreen")

@onready var healthbar = get_node("Healthbar")
@onready var manabar = get_node("Manabar")

func blackout():
	blackscreen.fade()


func _on_player_hud_update(health, mana) -> void:
	healthbar.update(int(health))
	manabar.update(int(mana))
