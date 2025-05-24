class_name HangingState
extends State

func enter() -> void:
	state_owner.velocity.x = 0
	state_owner.velocity.y = 0
	state_owner.animated_sprite.play("hanging")


func physics_update(_delta: float) -> void:
	state_owner.animated_sprite.flip_h = state_owner.facing_right < 0
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		change_state("SwingState")
	if Input.is_action_just_pressed("jump"):
		state_owner.jump_pressed = true
		change_state("JumpState")
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		change_state("HangSpinState")
