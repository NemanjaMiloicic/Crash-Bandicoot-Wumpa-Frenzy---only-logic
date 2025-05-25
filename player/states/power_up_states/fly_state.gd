class_name FlyState
extends State

const PROPPELER_SPEED := 90
func enter() -> void:
	state_owner.animated_sprite.play("fly")
	state_owner.fly_stream_player.play()

func physics_update(_delta: float) -> void:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("jump"):
		change_state("IdleState")
	
	var input_vector = Vector2(direction_x, direction_y)
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	
	if (state_owner.facing_right == 1 and direction_x < 0) or (state_owner.facing_right == -1 and direction_x > 0):
		state_owner.animated_sprite.play("fly_turn")

	state_owner.animated_sprite.flip_h = state_owner.facing_right < 0
	state_owner.velocity = input_vector * PROPPELER_SPEED
	
	if Input.is_action_just_pressed("spin"):
		if state_owner.spin_cooldown.is_stopped():
			state_owner.spin_cooldown.start()
			state_owner.spin_cooldown.start()
			state_owner.spin_stream_player.play()
			state_owner.destroy_crates()
			state_owner.animated_sprite.play("fly_spin")


func exit() -> void:
	state_owner.fly_stream_player.stop()

func on_animation_finished() -> void:
	state_owner.animated_sprite.play("fly")
