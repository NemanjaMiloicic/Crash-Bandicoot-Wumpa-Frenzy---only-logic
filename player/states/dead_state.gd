class_name DeadState
extends State

const FLY = -35

func enter() -> void:
	state_owner.animated_sprite.play("default_death")
	state_owner.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
		state_owner.velocity = Vector2(0, FLY)
	
	
