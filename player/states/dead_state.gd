class_name DeadState
extends State

const FLY = -35

func enter() -> void:
	if not state_owner.fire:
		state_owner.death_stream_player_2d.play()
	else:
		state_owner.blink_stream_player_2d.play()
		state_owner.fire_death_stream_player_2d.play()
	if state_owner.electricity:
		state_owner.electric_death_stream_player_2d.play()
		state_owner.animated_sprite.play("electric_death")
	elif state_owner.fire:
		state_owner.animated_sprite.play("fire_death")
	else:
		state_owner.animated_sprite.play("default_death")
	state_owner.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if not state_owner.electricity and not state_owner.fire:
		state_owner.velocity = Vector2(0, FLY)
	
	
