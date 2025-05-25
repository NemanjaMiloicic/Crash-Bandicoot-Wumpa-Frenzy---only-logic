extends AudioStreamPlayer

func _ready() -> void:
	randomize()

func play_with_random_pitch() -> void:
	pitch_scale = randf_range(1.2, 1.5)
	play()
