extends Level

var bounds
@onready var HUD = $CanvasLayer

@onready var respawn = get_node("Respawn")

func _ready():
	bounds = $%CollisionShape2D
	level_loader._on_scene_loaded(self)

func blackscreen():
	HUD.blackout()
	await get_tree().create_timer(1.0).timeout
	%Player.global_position = get_node("Respawn").global_position
	await get_tree().create_timer(0.5).timeout
	%Player.respawned()
