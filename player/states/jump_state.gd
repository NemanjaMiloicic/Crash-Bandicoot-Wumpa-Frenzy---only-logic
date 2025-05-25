class_name JumpState
extends State

var slid_jumped = false
func enter() -> void:
	if state_owner.jump_pressed:
		state_owner.jump_stream_player.play()
		
	if state_owner.jump_pressed and (
	state_owner.previous_state is SlideState
	or state_owner.previous_state is CrouchState
	or state_owner.previous_state is CrawlState
	):
		slid_jumped = true
		state_owner.animated_sprite.play("slide_jump")
	else:
		slid_jumped = false
		state_owner.animated_sprite.play("jump")

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		state_owner.jump_pressed = false
		change_state("SpinState")

	if state_owner.got_crystal and state_owner.is_on_floor():
		change_state("VictoryState")
		return

	# Gravity
	if slid_jumped:
		state_owner.velocity += state_owner.get_gravity() * delta + Vector2(0,state_owner.SLIDE_JUMP_BOOST)
	else:
		state_owner.velocity += state_owner.get_gravity() * delta
	

	# Input & movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_owner.animated_sprite.flip_h = direction < 0
		state_owner.velocity.x = direction * state_owner.SPEED
	else:
		state_owner.velocity.x = move_toward(state_owner.velocity.x, 0, state_owner.SPEED)
	
	if not slid_jumped and Input.is_action_just_pressed("crouch") and state_owner.velocity.y <= 0:
		change_state("BellyFlopState")
	
	if not state_owner.is_on_floor() and Input.is_action_just_pressed("crouch"):
		state_owner.slide_leniency.start()
	
	
	if state_owner.is_on_floor():
		var collision = state_owner.get_last_slide_collision()
		if collision:
			var other = collision.get_collider()
			if not other.name.begins_with("GridCrate"):
				if not state_owner.slide_leniency.is_stopped() and Input.is_action_pressed("crouch"):
					if Input.get_axis("move_left" , "move_right")!=0:
						change_state("SlideState")
					else:
						change_state("CrouchState")
					return 

		if direction == 0:
			change_state("IdleState")
		else:
			change_state("RunState")
