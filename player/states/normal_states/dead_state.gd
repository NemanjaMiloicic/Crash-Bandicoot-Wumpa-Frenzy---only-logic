class_name DeadState
extends State

const FLY = -35

func enter() -> void:
	if state_owner.death != DeathState.FIRE:
		state_owner.death_stream_player.play()
		
	else:
		state_owner.blink_stream_player.play()
		state_owner.fire_death_stream_player.play()
		
	if state_owner.death == DeathState.ELECTRICITY:
		state_owner.electric_death_stream_player.play()
		state_owner.animated_sprite.play("electric_death")
		
	elif state_owner.death == DeathState.FIRE:
		state_owner.animated_sprite.play("fire_death")
	
	elif state_owner.death == DeathState.EXPLOSION:
		state_owner.animated_sprite.play("explosion_death")
	
	else:
		state_owner.animated_sprite.play("default_death")
	state_owner.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if state_owner.death == DeathState.DEFAULT:
		state_owner.velocity = Vector2(0, FLY)
		if state_owner.collision_shape_2d and is_instance_valid(state_owner.collision_shape_2d):
			state_owner.collision_shape_2d.queue_free()
	
	
