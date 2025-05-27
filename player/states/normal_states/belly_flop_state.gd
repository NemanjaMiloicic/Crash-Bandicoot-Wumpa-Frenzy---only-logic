class_name BellyFlopState
extends State

const BELLY_FLOP_BOOST = -150

func enter() -> void:
	state_owner.animated_sprite.play("belly_flop")
	state_owner.velocity.y = BELLY_FLOP_BOOST
	state_owner.velocity.x = move_toward(state_owner.velocity.x, 0, state_owner.speed)
	
func physics_update(delta: float) -> void:
	state_owner.destroy_crates()
	state_owner.velocity += state_owner.get_gravity() * delta
	
	if state_owner.is_on_floor():
		var collision = state_owner.get_last_slide_collision()
		if collision:
			var other = collision.get_collider()
			if not other.name.begins_with("GridCrate"):
				change_state("HitGroundState")
