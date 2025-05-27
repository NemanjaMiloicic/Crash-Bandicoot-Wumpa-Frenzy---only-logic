class_name JumpState
extends State

var slid_jumped = false

func enter() -> void:
	if state_owner.jump_pressed:
		state_owner.jump_stream_player.play()

	slid_jumped = state_owner.jump_pressed and (
		state_owner.previous_state is SlideState
		or state_owner.previous_state is CrouchState
		or state_owner.previous_state is CrawlState
	)

	if slid_jumped:
		state_owner.animated_sprite.play("slide_jump")
	else:
		state_owner.animated_sprite.play("jump")

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		state_owner.jump_pressed = false
		change_state("SpinState")
		return

	if state_owner.got_crystal and state_owner.is_on_floor():
		change_state("VictoryState")
		return

	# Gravity
	var gravity_effect = state_owner.get_gravity() * delta
	if slid_jumped:
		gravity_effect += Vector2(0, state_owner.SLIDE_JUMP_BOOST)
	state_owner.velocity += gravity_effect

	# Movement input
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_owner.animated_sprite.flip_h = direction < 0
		state_owner.velocity.x = direction * state_owner.speed
	else:
		state_owner.velocity.x = move_toward(state_owner.velocity.x, 0, state_owner.speed)

	# Belly flop check
	if not slid_jumped and Input.is_action_just_pressed("crouch") and state_owner.velocity.y <= 0:
		change_state("BellyFlopState")
		return

	if not state_owner.is_on_floor():
		if Input.is_action_just_pressed("crouch"):
			state_owner.slide_leniency.start()
		return

	# On floor, handle landing states
	var collision = state_owner.get_last_slide_collision()
	if collision:
		var other = collision.get_collider()
		if not other.name.begins_with("GridCrate"):
			if not state_owner.slide_leniency.is_stopped() and Input.is_action_pressed("crouch"):
				if direction != 0:
					change_state("SlideState")
				else:
					change_state("CrouchState")
				return

	if direction == 0:
		change_state("IdleState")
	else:
		change_state("RunState")
