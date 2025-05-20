extends Area2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

#body player
func _on_body_entered(body: Node2D) -> void:
	audio_stream_player_2d.play()
	body.get_node("CollisionShape2D").queue_free()
	body.current_state.change_state("DeadState")
	timer.start()

func _on_timer_timeout() -> void:
	
	get_tree().reload_current_scene()
	
