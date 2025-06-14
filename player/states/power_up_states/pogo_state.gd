class_name PogoState
extends State

const POGO_SPEED := 70
const LAND_LOCKOUT_TIME := 0.3  

var was_in_air := false
var lockout_active := false

func enter() -> void:
	state_owner.animated_sprite.play("pogo")
	was_in_air = false
	lockout_active = false

func physics_update(delta: float) -> void:
	state_owner.destroy_crates_activate_tnt()
	if Input.is_action_just_pressed("jump"):
		change_state("JumpState")
	if not state_owner.is_on_floor():
		was_in_air = true
	elif was_in_air:
		was_in_air = false
		lockout_active = true
		state_owner.animated_sprite.play("pogo")
		state_owner.velocity = Vector2.ZERO  
		var timer := state_owner.get_tree().create_timer(LAND_LOCKOUT_TIME)
		timer.timeout.connect(_on_lockout_timeout)

	var input_vector := Vector2.ZERO

	if not lockout_active:
		if Input.is_action_pressed("ui_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1

	input_vector = input_vector.normalized()

	
	if input_vector.x != 0:
		state_owner.facing_right = sign(input_vector.x)
		state_owner.animated_sprite.flip_h = state_owner.facing_right == -1

	if state_owner.is_on_floor():
		if input_vector.x != 0 and not lockout_active:
			state_owner.animated_sprite.play("pogo_jump")
			state_owner.velocity.x = input_vector.x * POGO_SPEED
			state_owner.velocity.y = -500 
			state_owner.pogo_stream_player.play()  
	else:
		state_owner.velocity.x = input_vector.x * POGO_SPEED

	state_owner.velocity.y += state_owner.get_gravity().y * delta

func _on_lockout_timeout() -> void:
	lockout_active = false
