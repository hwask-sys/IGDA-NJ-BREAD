extends Timer



func _on_timeout() -> void:
	wait_time = randi_range(4,7)
	#wait_time = 1


func _on_angel_phase_over() -> void:
	stop()
