class_name CrouchState
extends State

func enter() -> void:
	state_owner.animated_sprite.play("crouch")
	state_owner.shrink_collider()
	state_owner.velocity.x = 0
	state_owner.velocity.y = 0
	
func physics_update(_delta: float) -> void:
	if not state_owner.is_on_floor():
		change_state("JumpState")
		
	if not Input.is_action_pressed("crouch"):
		if state_owner.can_stand_up():
			change_state("IdleState")
		
	if Input.is_action_just_pressed("jump") and state_owner.can_stand_up():
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_owner.animated_sprite.flip_h = direction < 0
		change_state("CrawlState")
		
func exit() -> void:
	state_owner.restore_collider()
