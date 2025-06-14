class_name JumpState
extends State


func enter() -> void:
	if state_owner.jump_pressed:
		state_owner.jump_stream_player.play()

	state_owner.slid_jumped = state_owner.jump_pressed and (
		state_owner.previous_state is SlideState
		or state_owner.previous_state is CrouchState
		or state_owner.previous_state is CrawlState
	)

	if state_owner.slid_jumped:
		state_owner.animated_sprite.play("slide_jump")
	else:
		state_owner.animated_sprite.play("jump")

func physics_update(delta: float) -> void:
	
	var gravity = state_owner.get_gravity()
	
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		state_owner.jump_pressed = false
		change_state("SpinState")
		return

	if state_owner.got_crystal and state_owner.is_on_floor():
		change_state("VictoryState")
		return
	
	elif state_owner.velocity.y < 0 and not Input.is_action_pressed("jump"):
		gravity *= 1.5
	
	elif state_owner.velocity.y < 0 and Input.is_action_pressed("jump"):
		gravity *= 0.88  # slabiji efekat gravitacije
	
	# Gravity
	var gravity_effect = gravity * delta
	if state_owner.slid_jumped:
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
	if not state_owner.slid_jumped and Input.is_action_just_pressed("crouch") and state_owner.velocity.y <= 0:
		change_state("BellyFlopState")
		return

	if not state_owner.is_on_floor():
		if Input.is_action_just_pressed("crouch"):
			state_owner.slide_leniency.start()
		return

	# On floor, handle landing states
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
