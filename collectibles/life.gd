extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var entered_once = false

func _ready():
	if GameManager.collected_lives.has(global_position):
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		if not entered_once:
			GameManager.add_life(global_position)
			audio_stream_player.play()
			entered_once = true
			sprite_2d.visible = false
		await audio_stream_player.finished
	queue_free()
