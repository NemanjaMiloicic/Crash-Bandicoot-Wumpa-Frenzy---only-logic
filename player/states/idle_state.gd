class_name IdleState
extends State


func enter() -> void:
	state_owner.velocity.x = 0
	state_owner.velocity.y = 0
	state_owner.animated_sprite.play("idle")

func physics_update(_delta: float) -> void:
	if not state_owner.is_on_floor():
		change_state("JumpState")
		return
		
	if Input.is_action_just_pressed("jump"):
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
		return
	
	if Input.is_action_just_pressed("spin") and state_owner.can_spin:
		change_state("SpinState")
	
	if Input.is_action_just_pressed("crouch"):
		change_state("CrouchState")
		
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_owner.check_direction(direction)
		change_state("RunState")
