extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		audio_stream_player.play()
		timer.start()
		var direction = -1 if scale.x < 0 else 1
		body.states["RocketState"].direction = direction
		body.current_state.change_state("RocketState")
		collision_shape_2d.set_deferred("disabled", true)
		visible = false

func _on_timer_timeout() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	visible = true
