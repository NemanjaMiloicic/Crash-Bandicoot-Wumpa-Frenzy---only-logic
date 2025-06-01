class_name SlideState
extends State

var current_facing 

func enter() -> void:
	state_owner.attacking = true
	state_owner.animated_sprite.play("slide")
	state_owner.slide_stream_player.play()
	state_owner.slide_cooldown.start()
	state_owner.can_slide = false
	state_owner.shrink_collider()
	current_facing = state_owner.facing_right
	
func physics_update(_delta: float) -> void:
	state_owner.destroy_crates()
	
	if Input.is_action_just_pressed("spin"):
		change_state("SpinState")
		return
	
	if Input.is_action_just_pressed("jump") and state_owner.can_stand_up():
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		change_state("JumpState")
		return
	
	state_owner.velocity.x =  current_facing*state_owner.SPEED*1.25

func exit() -> void:
	state_owner.attacking = false
	state_owner.slide_collision_reset = true
		
func on_animation_finished():
	if not state_owner.is_on_floor():
		state_owner.jump_pressed = false
		change_state("JumpState")
	if state_owner.is_on_floor() and state_owner.can_stand_up():
		state_owner.velocity.x = 0
		state_owner.velocity.y = 0
		change_state("IdleState")
	if state_owner.is_on_floor() and not state_owner.can_stand_up():
		change_state("CrouchState")
