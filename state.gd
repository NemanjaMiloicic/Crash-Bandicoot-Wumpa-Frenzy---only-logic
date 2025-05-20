extends Node

class_name State

var state_owner : Player

func enter() -> void:
	pass
	
func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func change_state(state_name: String) -> void:
	if not state_owner.states.has(state_name):
		push_error("State '%s' does not exist!" % state_name)
		return
	
	if state_owner.current_state == state_owner.states[state_name]:
		return
	
	state_owner.previous_state = state_owner.current_state
	state_owner.current_state.exit()
	state_owner.current_state = state_owner.states[state_name]
	state_owner.current_state.enter()

func on_animation_finished() -> void:
	pass
