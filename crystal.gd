extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var entered_once = false
func _on_body_entered(body: Node2D) -> void:
	body.got_crystal = true
	if not entered_once:
		audio_stream_player.play()
		entered_once = true
		animated_sprite_2d.visible = false
	await  audio_stream_player.finished
	queue_free()
	
