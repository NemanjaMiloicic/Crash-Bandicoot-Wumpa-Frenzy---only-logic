class_name ArmoredCrate
extends NormalCrate

@onready var land: AudioStreamPlayer2D = $Land


func _ready() -> void:
	super._ready()
	drop_scene = preload("res://scenes/collectibles/wumpa_fruit_x_5.tscn")

func _on_crate_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		body.near_armored_crates.append(self)
		
func _on_crate_body_exited(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		body.near_armored_crates.erase(self)

func _on_top_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or body.current_state is BellyFlopState:
		return
	if broken:
		return
	land.play()
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("land")

func _on_bottom_body_entered(_body: Node2D) -> void:
	pass
	
func explode_crate():
	pass
	
func destroy(near_metal_crates):
	super.destroy(near_metal_crates)
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation != "land":
		return
	animated_sprite_2d.visible = false
	if not broken:
		sprite_2d.visible = true
