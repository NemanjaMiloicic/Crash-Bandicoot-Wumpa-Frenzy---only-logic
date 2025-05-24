class_name CrawlState
extends State


func enter() -> void:
	state_owner.animated_sprite.play("crawl")
	state_owner.shrink_collider()

func physics_update(delta: float) -> void:
	
	if not state_owner.is_on_floor():
		state_owner.jump_pressed = false
		change_state("JumpState")
	var direction = Input.get_axis("move_left", "move_right")
	
	
	if direction != 0:
		state_owner.animated_sprite.flip_h = direction < 0
		state_owner.velocity.x = direction * state_owner.SPEED/2.5
	else:
		change_state("CrouchState")
		
	if Input.is_action_just_pressed("jump") and state_owner.can_stand_up():
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
	
	if not Input.is_action_pressed("crouch") and state_owner.can_stand_up():
		if direction != 0:
			change_state("RunState")
		else:
			change_state("IdleState")
		
	state_owner.velocity += state_owner.get_gravity() * delta
		
func exit() -> void:
	state_owner.restore_collider()
