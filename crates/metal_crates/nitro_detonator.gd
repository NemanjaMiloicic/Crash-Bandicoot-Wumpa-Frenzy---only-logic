class_name NitroDetonator
extends StaticBody2D

var activated = false
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var activated_sprite_2d: Sprite2D = $Activated
@onready var broken_crate: AudioStreamPlayer2D = $BrokenCrate



func _on_crate_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body.is_in_group("player"):
		body.near_metal_crates.append(self)


func _on_crate_body_exited(body: Node2D) -> void:
	if activated:
		return
	if body.is_in_group("player"):
		body.near_metal_crates.erase(self)



func _on_top_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body.current_state is BellyFlopState:
		activate()
	else:
		CrateHelper.bounce_of_crate(self , body , false)


func _on_bottom_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body.is_in_group("player"):
		if global_position.y < body.global_position.y and not body.attacking and body.current_state is JumpState: 
			body.animated_sprite.play("jump")
			body.move_and_slide()
	activate()
	
func activate() -> void:
	if activated:
		return
	activated = true
	sprite_2d.visible = false
	activated_sprite_2d.visible = true
	broken_crate.play()
	for node in get_tree().get_nodes_in_group("exploding_crate"):
		if not node.broken:
			node.explode_crate()
			GameManager.add_crates()
	GameManager.currently_activated_switches.append(global_position)
	
	
