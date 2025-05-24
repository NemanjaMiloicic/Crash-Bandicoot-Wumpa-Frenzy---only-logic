class_name SwingState
extends State

const SWING_SPEED := 90


func enter() -> void:
	state_owner.animated_sprite.play("swing")
	state_owner.swinging_stream_player_2d.play()

func physics_update(_delta: float) -> void:
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 0:
		change_state("HangingState")
	
	state_owner.animated_sprite.flip_h = direction < 0
	state_owner.velocity.x = direction * SWING_SPEED
	
	if Input.is_action_just_pressed("jump"):
		state_owner.jump_pressed = true
		change_state("JumpState")
	
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		change_state("HangSpinState")

func exit() -> void:
	state_owner.swinging_stream_player_2d.stop()
