extends Node
## Right now this is purely for transition purposes. DO NOT modify this class and your base node
## should be of type Level. The only thing you will need to note about this class is that you can
## set the song of your level by giving this level object a music_stream
class_name Level

## The song that will play in the background of your level
@export var music_stream: AudioStream
## Do not touch this value
@export var level_id: int


# Called when the node enters the scene tree for the first time.
func _ready():
	level_loader._on_scene_loaded(self)
