class_name RocketState
extends State

const MAX_SPEED = 150
const BASE_SPEED = 90
const ACCELERATION = 1

var current_speed = BASE_SPEED
var direction
func enter() -> void:
	state_owner.speed_stream_player.play_with_random_pitch()
	state_owner.animated_sprite.play("rocket_shoes")
	current_speed = BASE_SPEED
	
	if direction != 0:
		state_owner.animated_sprite.flip_h = (direction < 0)

func physics_update(_delta: float) -> void:
	state_owner.destroy_crates()
	if current_speed < MAX_SPEED:
		current_speed += ACCELERATION
	
	var direction_x = direction
	
	
	var direction_y = Input.get_axis("up", "down")
	state_owner.velocity.x = current_speed * direction_x
	state_owner.velocity.y = current_speed * direction_y
	
	
	var collided_with_wall =  state_owner.is_on_wall() 
	
	if collided_with_wall:
		var collision = state_owner.get_last_slide_collision()
		var collider = collision.get_collider()
		if not collider.is_in_group("crates"):
			if state_owner.is_on_floor():
				change_state("IdleState")
			else:
				change_state("JumpState")

func exit() -> void :
	state_owner.speed_stream_player.stop()
