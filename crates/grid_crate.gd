class_name GridCrate
extends NormalCrate

@onready var bounce: AudioStreamPlayer2D = $Bounce
@onready var wumpa: AudioStreamPlayer2D = $Wumpa
@onready var timer: Timer = $Timer

const JUMPS := 5
var current_jumps 
const WUMPAS_PER_JUMP := 2
var first_hit := true
func _ready() -> void:
	current_jumps = 0
	super._ready()
	drop_scene = ""


func _on_top_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or not body.current_state is JumpState:
		return
	if broken or body.attacking:
		return
	if first_hit:
		timer.start()
		first_hit = false
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("bounce")
	if current_jumps < JUMPS - 1:
		CrateHelper.bounce_of_crate(self , body , false)
		bounce.play()
		wumpa.play()
	else:
		CrateHelper.bounce_of_crate(self , body , true)
		destroy(body.near_crates)
	
	for i in range(WUMPAS_PER_JUMP):
		GameManager.add_wumpas()
	
	current_jumps += 1
		

func _on_bottom_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		if global_position.y < body.global_position.y and not body.attacking and body.current_state is JumpState:
			if first_hit:
				timer.start()
				first_hit = false
			sprite_2d.visible = false
			animated_sprite_2d.visible = true
			animated_sprite_2d.play("bounce")
			body.animated_sprite.play("jump")
			body.move_and_slide()
			if current_jumps < JUMPS - 1:
				bounce.play()
				wumpa.play()
			else:
				destroy(body.near_crates)
				GameManager.add_crates()
	
	for i in range(WUMPAS_PER_JUMP):
		GameManager.add_wumpas()
	
	current_jumps += 1
			


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation != "bounce":
		return
	animated_sprite_2d.visible = false
	if not broken:
		sprite_2d.visible = true


func _on_timer_timeout() -> void:
	current_jumps = JUMPS - 1
