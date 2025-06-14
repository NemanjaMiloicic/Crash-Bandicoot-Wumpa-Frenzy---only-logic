class_name JetBoardIdleState
extends State

const DECELARTION := 100
func enter() -> void:
	state_owner.animated_sprite.play("jetboard_idle")
	state_owner.velocity.y = 0
	state_owner.jetboard_running.play()

func physics_update(delta: float) -> void:
	state_owner.destroy_crates()
	state_owner.velocity.x = move_toward(state_owner.velocity.x, 0.0, DECELARTION * delta)

	var gravity_effect = state_owner.get_gravity() * delta
	state_owner.velocity += gravity_effect
	
	if Input.is_key_pressed(KEY_P):
		change_state("FlyState")
	
	if Input.is_action_just_pressed("jump") and state_owner.is_on_floor():
		state_owner.velocity.y = state_owner.JUMP_VELOCITY
	
	if Input.is_action_just_pressed("spin"):
		change_state("JetBoardBoostState")
		
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		change_state("JetBoardMovingState")
		
	if state_owner.facing_right == -1:
		state_owner.animated_sprite.flip_h = true

func exit() -> void:
		state_owner.jetboard_running.stop()
