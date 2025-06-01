extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $HitZone/CollisionShape2D

func _ready() -> void:
	audio_stream_player.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.set_deferred("disabled" , true)
