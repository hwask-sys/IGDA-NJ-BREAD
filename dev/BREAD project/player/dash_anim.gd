extends TextureProgressBar

func _ready() -> void:
	max_value = get_parent().DASHBUFFERTIME * 100


func _on_player_animate_dash(x) -> void:
	value = max_value - x * 100
