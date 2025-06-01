extends Area2D

@onready var death_timer: Timer = $DeathTimer
@onready var damage_timer: Timer = $DamageTimer
var player
var is_in_body = false
func _on_body_entered(body: Node2D) -> void:
	if body.name != "CharacterBody2D":
		return
	
	#kind of death
	is_in_body = true
	player = body
	var parent = get_parent()
	if parent and parent.is_in_group("electric"):
		body.death = DeathState.ELECTRICITY
	elif parent and parent.is_in_group("fire"):
		body.death = DeathState.FIRE
	
	elif parent and parent.is_in_group("explosion"):
		body.death = DeathState.EXPLOSION
	else:
		body.death = DeathState.DEFAULT
	
	
	# if he doesn't have I frames he gets hit once or dies if protection is 0
	while is_in_body:
		if body.invincibility_time.is_stopped():
			if GameManager.killed():
				is_in_body = false
				body.current_state.change_state("DeadState")
				death_timer.start()
			else:
				body.animation_player.play("flash")
				body.invincibility_time.start()
				damage_timer.start()  
		await get_tree().create_timer(0.1).timeout	

func _on_timer_timeout() -> void:
	GameManager.die()
	get_tree().reload_current_scene()
	


func _on_damage_timer_timeout() -> void:

	# I frames ran out but player is still in hitzone he gets hit again
	# or killed if protection is 0
	if player.invincibility_time.is_stopped():
		if GameManager.killed():
			damage_timer.stop()
			player.current_state.change_state("DeadState")
			death_timer.start()
		else:
			#if playes still isn't dead and is still in hit zone grant I frames
			#start damage timer again
			player.animation_player.play("flash")
			player.invincibility_time.start()
			damage_timer.start()


func _on_body_exited(body: Node2D) -> void:
	is_in_body = false
	if body == player:
		damage_timer.stop()
