class_name RunState
extends State

func enter() -> void:
	state_owner.animated_sprite.play("run")
	state_owner.run_stream_player.play()

func physics_update(_delta: float) -> void:
	if state_owner.got_crystal and state_owner.is_on_floor():
		change_state("VictoryState")
		return
	
	if not state_owner.is_on_floor():
		state_owner.jump_pressed = false
		change_state("JumpState")
		return
	
	if Input.is_action_just_pressed("jump"):
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
		return
	
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		change_state("SpinState")
		return
		
	if Input.is_action_just_pressed("crouch") and state_owner.is_on_floor() and state_owner.can_slide:
		change_state("SlideState")
		
	var direction = Input.get_axis("move_left", "move_right")

	if direction == 0:
		state_owner.velocity.x = 0  
		change_state("IdleState")
		return


	state_owner.animated_sprite.flip_h = direction < 0
	state_owner.velocity.x = direction * state_owner.SPEED

func exit() -> void:
	state_owner.run_stream_player.stop()
