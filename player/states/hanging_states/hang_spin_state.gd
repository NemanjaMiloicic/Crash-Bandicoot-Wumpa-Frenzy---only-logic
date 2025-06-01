class_name HangSpinState
extends State

func enter() -> void:
	state_owner.attacking = true
	state_owner.velocity.x = 0
	state_owner.velocity.y = 0
	state_owner.can_spin = false
	state_owner.spin_cooldown.start()
	state_owner.spin_stream_player.play()
	state_owner.animated_sprite.play("hang_spin")


func physics_update(_delta: float) -> void:
	state_owner.destroy_crates()
	
func on_animation_finished():
	change_state("HangingState")

func exit() -> void:
	state_owner.attacking = false
