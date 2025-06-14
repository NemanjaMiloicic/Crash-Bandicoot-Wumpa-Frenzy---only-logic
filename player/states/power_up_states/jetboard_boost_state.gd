class_name JetBoardBoostState
extends State



const BOOST_JUMP := -50
const ACCELERATION_TIME := 2.0


var initial_direction
func enter() -> void:
	state_owner.animated_sprite.play("jetboard_speeding")
	initial_direction = state_owner.facing_right
	state_owner.jetboard_boost.play()
	state_owner.jetboard_running.pitch_scale = 2.0
	state_owner.jetboard_running.play()
	if initial_direction == -1:
		state_owner.animated_sprite.flip_h = true
	start_boost_sequence()
func physics_update(delta: float) -> void:
	
	state_owner.destroy_crates()

	var gravity_effect = state_owner.get_gravity() * delta
	state_owner.velocity += gravity_effect
	if Input.is_action_just_pressed("jump") and state_owner.is_on_floor():
		state_owner.velocity.y = state_owner.JUMP_VELOCITY + BOOST_JUMP
	
	state_owner.velocity.x = move_toward(
	state_owner.velocity.x,
	initial_direction * 200,
	700 * delta
	)

func start_boost_sequence() -> void:
	await state_owner.get_tree().create_timer(ACCELERATION_TIME).timeout

	var direction = Input.get_axis("move_left", "move_right")
	if state_owner.current_state is JetBoardBoostState:
		if direction != 0:
			change_state("JetBoardMovingState")
		else:
			change_state("JetBoardIdleState")

func exit() -> void:
	state_owner.jetboard_running.stop()
	state_owner.jetboard_running.pitch_scale = 1.0
