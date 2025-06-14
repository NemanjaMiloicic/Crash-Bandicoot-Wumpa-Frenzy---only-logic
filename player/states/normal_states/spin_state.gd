class_name SpinState
extends State

func enter() -> void:
	state_owner.attacking = true
	state_owner.can_spin = false
	state_owner.spin_cooldown.start()
	state_owner.animated_sprite.play("spin")
	state_owner.spin_stream_player.play()

func physics_update(delta: float) -> void:
	state_owner.destroy_crates()
	
	state_owner.velocity += state_owner.get_gravity() * delta
	
	if state_owner.got_crystal and state_owner.is_on_floor():
		change_state("VictoryState")
		return

	
	if Input.is_action_just_pressed("jump") and state_owner.is_on_floor():
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
		return

	var direction = Input.get_axis("move_left", "move_right")


	state_owner.animated_sprite.flip_h = direction < 0
	state_owner.velocity.x = direction * state_owner.speed

func on_animation_finished() -> void:
	if state_owner.is_on_floor():
		change_state("IdleState")
	else:
		change_state("JumpState")

func exit() -> void:
	state_owner.attacking = false
