class_name TntCrate
extends NormalCrate



@onready var timer: Timer = $Timer
@onready var tnt_timer: AudioStreamPlayer2D = $TntTimer


var first_jump := true
var activated := false
func _ready() -> void:
	super._ready()
	drop_scene = preload("res://scenes/hazards/tnt_explosion.tscn")
	animation = ''
	


func destroy(near_crates) -> void:
	if not timer.is_stopped():
		timer.stop()
	super.destroy(near_crates)



func _on_top_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or not body.current_state is JumpState:
		return
	if broken or body.attacking:
		return
	if not first_jump:
		return
	activate()
	CrateHelper.bounce_of_crate(self , body , false)
	timer.start()
	first_jump = false
	
			
	

func _on_bottom_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		if global_position.y < body.global_position.y and not body.attacking and body.current_state is JumpState:
			if first_jump:
				activate()
				body.animated_sprite.play("jump")
				body.move_and_slide()


func explode_crate():
	super.explode_crate()
	var drop = drop_scene.instantiate()
	drop.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", drop)

func activate():
	if activated:
		return
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	tnt_timer.play()
	animated_sprite_2d.play("tnt_timer")
	timer.start()
	first_jump = false
	activated = true


func _on_timer_timeout() -> void:
	explode_crate()
	GameManager.add_crates()
