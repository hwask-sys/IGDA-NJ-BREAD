extends Level

var bounds

func _ready():
	bounds = $%CollisionShape2D
	level_loader._on_scene_loaded(self)
