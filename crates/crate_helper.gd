class_name 	CrateHelper
extends Node

const BOOST_SLID := 20
const BOOST_REGULAR := 60
const BOOST_BOUNCY := 45
static func bounce_of_crate(crate: Node2D, body: Node2D, counted: bool) -> void:
	if body.is_in_group("player"):
		if crate.global_position.y > body.global_position.y and not body.attacking and body.current_state is JumpState:
			if crate.is_in_group("activatable_crate"):
				crate.activate()
			body.animated_sprite.play("jump")
			if not body.slid_jumped:
				body.velocity.y = body.JUMP_VELOCITY - BOOST_REGULAR
			else:
				body.velocity.y = body.JUMP_VELOCITY + BOOST_SLID
			if crate is BouncyCrate:
				body.velocity.y -= BOOST_BOUNCY
			body.move_and_slide()
			if counted:
				crate.destroy(body.near_crates)
				GameManager.add_crates()
