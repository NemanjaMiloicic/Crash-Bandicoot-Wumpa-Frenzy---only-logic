extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



func _on_body_entered(body: Node2D) -> void:
	var body_height = body.collision_shape_2d.shape.radius*24
	if body.is_in_group("player"):
		body.current_state.change_state("HangingState")
		body.position.y = collision_shape_2d.shape.extents.y + collision_shape_2d.global_position.y + body_height


func _on_left_edge_body_entered(body: Node2D) -> void:
	let_go_of_chain(body)


func _on_right_edge_body_entered(body: Node2D) -> void:
	let_go_of_chain(body)


func let_go_of_chain(body : Node2D) -> void:
	if body.is_in_group("player"):
		if body.current_state is not JumpState:
			body.current_state.change_state("JumpState")
			
