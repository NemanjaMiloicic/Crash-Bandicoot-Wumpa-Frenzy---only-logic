class_name VictoryState
extends State

const YEEHAW = 1.95

func enter() -> void:
	state_owner.animated_sprite.play("victory_dance")
	await state_owner.get_tree().create_timer(YEEHAW).timeout
	state_owner.victory_stream_player_2d.play()
	state_owner.got_crystal = false

func physics_update(_delta: float) -> void:
	state_owner.velocity.x = 0
	state_owner.velocity.y = 0
	
func on_animation_finished() -> void:
	change_state("IdleState")
