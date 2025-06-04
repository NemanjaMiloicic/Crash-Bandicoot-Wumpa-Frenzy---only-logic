extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bounce: AudioStreamPlayer2D = $Bounce


func _on_top_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or not body.current_state is JumpState:
		return
	
	CrateHelper.bounce_of_crate(self , body , false)
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("bounce")
	bounce.play()



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation != "bounce":
		return
	animated_sprite_2d.visible = false
	sprite_2d.visible = true
