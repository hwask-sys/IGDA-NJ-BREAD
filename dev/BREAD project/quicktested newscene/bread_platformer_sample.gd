extends Level

var bounds
@onready var HUD = $CanvasLayer
@onready var respawn = get_node("Respawn")

@onready var angel = get_node("Angel")

#songs
var basesong = preload("res://dev/BREAD project/music/B.R.E.A.D. looped .ogg")
var transitions = preload("res://dev/BREAD project/music/B.R.E.A.D.between.ogg")

signal darken
signal brighten

func _ready():
	bounds = $%CollisionShape2D
	level_loader._on_scene_loaded(self)

func blackscreen():
	HUD.blackout()
	await get_tree().create_timer(1.0).timeout
	%Player.global_position = get_node("Respawn").global_position
	await get_tree().create_timer(0.5).timeout
	%Player.respawned()

func respawn_angel(gp):
	#music_stream = basesong
	#sound_player.change_song(music_stream)
	angel.waitComeBackINeedYou(gp)
	brighten.emit()


func _on_angel_phase_over() -> void:
	darken.emit()
	#music_stream = transitions
	#sound_player.change_song(music_stream)
