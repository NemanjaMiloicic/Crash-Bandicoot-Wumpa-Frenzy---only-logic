extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $HitZone/CollisionShape2D

func _ready() -> void:
	audio_stream_player.play()
	
	var shape = collision_shape_2d.shape
	var center = collision_shape_2d.global_position
	var radius = shape.radius

	for node in get_tree().get_nodes_in_group("crates"):
		if not node.is_in_group("metal_crates") and node.global_position.distance_to(center) <= radius:
			if "broken" in node and not node.broken:
				GameManager.add_crates()
				node.explode_crate()
	
	for node in get_tree().get_nodes_in_group("enemy"):
		if node.global_position.distance_to(center) <= radius:
			node.die()
				
	
			
func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.set_deferred("disabled" , true)
