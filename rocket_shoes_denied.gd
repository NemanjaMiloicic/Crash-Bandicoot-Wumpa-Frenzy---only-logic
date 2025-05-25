extends Node2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D" and body.current_state is RocketState:
		if body.is_on_floor():
			body.current_state.change_state("IdleState")
		else:
			body.current_state.change_state("JumpState")
