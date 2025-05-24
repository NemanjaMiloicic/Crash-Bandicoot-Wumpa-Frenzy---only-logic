extends Area2D

@onready var timer: Timer = $Timer
#body player

func _on_body_entered(body: Node2D) -> void:
	var parent = get_parent()
	if parent and parent.name.begins_with("ElectricFence"):
		body.electricity = true
	elif parent and parent.name.begins_with("Bonfire"):
		body.fire = true
	body.current_state.change_state("DeadState")
	timer.start()

func _on_timer_timeout() -> void:
	
	get_tree().reload_current_scene()
	
