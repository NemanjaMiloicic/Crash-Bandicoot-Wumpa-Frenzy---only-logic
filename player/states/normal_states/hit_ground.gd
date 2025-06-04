class_name HitGroundState
extends State

func enter() -> void:
	state_owner.destroy_crates()
	state_owner.animated_sprite.play("hit_ground")
	state_owner.hit_ground_stream_player.play()
	state_owner.shrink_collider()

func exit() -> void:
		state_owner.restore_collider()

func physics_update(_delta: float) -> void:
	if state_owner.got_crystal:
		change_state("VictoryState")

func on_animation_finished() -> void:
	change_state("IdleState")
