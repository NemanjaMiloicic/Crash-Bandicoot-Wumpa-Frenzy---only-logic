class_name ChasingFrogState
extends State

func physics_update(delta: float) -> void:
	state_owner.velocity += state_owner.get_gravity() * delta

	if not state_owner.player:
		return

	var dir_to_player = state_owner.player.global_position.x - state_owner.global_position.x
	state_owner.direction = sign(dir_to_player)
	state_owner.animated_sprite_2d.flip_h = state_owner.direction < 0

	if state_owner.is_on_floor() and state_owner.can_move:
		if state_owner.can_jump:
			state_owner.velocity.x = state_owner.direction * state_owner.SPEED
			state_owner.can_jump = false

	if state_owner.is_on_floor() and not state_owner.is_jumping and state_owner.animated_sprite_2d.animation != "stand":
		state_owner.velocity = Vector2.ZERO
		state_owner.animated_sprite_2d.play("stand")
