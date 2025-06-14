extends Area2D

@onready var death_timer: Timer = $DeathTimer

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	#kind of death
	var parent = get_parent()
	if parent.is_dead:
		return
	if parent and parent.is_in_group("electric"):
		body.death = DeathState.ELECTRICITY
	elif parent and parent.is_in_group("fire"):
		body.death = DeathState.FIRE
	
	elif parent and parent.is_in_group("explosion"):
		body.death = DeathState.EXPLOSION
	else:
		body.death = DeathState.DEFAULT
	
	if body.attacking:
		if body.current_state is BellyFlopState:
			parent.die_by_bounce()
		else:
			parent.spun = true
			parent.die_by_hit(body)
	
	
	elif body.invincibility_time.is_stopped():
			if GameManager.killed():
				body.current_state.change_state("DeadState")
				death_timer.start()
			else:
				parent.die()
				body.animation_player.play("flash")
				body.invincibility_time.start()
		


func _on_death_timer_timeout() -> void:
	GameManager.die()
	get_tree().reload_current_scene()
