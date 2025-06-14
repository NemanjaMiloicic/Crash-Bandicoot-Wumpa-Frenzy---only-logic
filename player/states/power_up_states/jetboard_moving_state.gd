class_name JetBoardMovingState
extends State


func enter() -> void:
	state_owner.animated_sprite.play("jetboard_moving")
	state_owner.jetboard_running.play()
func physics_update(delta: float) -> void:
	
	state_owner.destroy_crates()
	var gravity_effect = state_owner.get_gravity() * delta
	state_owner.velocity += gravity_effect
	
	if Input.is_action_just_pressed("jump") and state_owner.is_on_floor():
		state_owner.jump_pressed = true
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
		return
	
	if Input.is_action_just_pressed("spin"):
		change_state("JetBoardBoostState")
		return
		
	
	var direction = Input.get_axis("move_left", "move_right")

	if direction == 0 and state_owner.is_on_floor():
		change_state("JetBoardIdleState")
		return


	state_owner.animated_sprite.flip_h = direction < 0
	state_owner.velocity.x = direction * state_owner.speed
	
	if state_owner.facing_right == -1:
		state_owner.animated_sprite.flip_h = true

func exit() -> void:
	state_owner.jetboard_running.stop()
