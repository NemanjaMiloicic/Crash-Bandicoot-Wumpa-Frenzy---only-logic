extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var sprite_2d: Sprite2D = $Sprite2D




var entered_once = false		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		if not entered_once:
			audio_stream_player_2d.play()
			entered_once = true
			sprite_2d.visible = false
		await audio_stream_player_2d.finished
	queue_free()
