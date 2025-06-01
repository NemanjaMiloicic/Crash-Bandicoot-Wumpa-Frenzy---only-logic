extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var entered_once = false

func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			if not entered_once:
				GameManager.got_aku()
				if GameManager.aku_protection != GameManager.MAX_AKU:
					audio_stream_player.play()
				entered_once = true
				sprite_2d.visible = false
			await audio_stream_player.finished
		queue_free()
