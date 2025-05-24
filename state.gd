extends Node

class_name State

var state_owner : Node

func _init(p_state_owner : Node) -> void:
	state_owner = p_state_owner

func enter() -> void:
	pass
	
func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func change_state(state_name: String) -> void:

	
	state_owner.previous_state = state_owner.current_state
	state_owner.current_state.exit()
	state_owner.current_state = state_owner.states[state_name]
	state_owner.current_state.enter()

func on_animation_finished() -> void:
	pass
