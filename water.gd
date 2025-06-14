extends StaticBody2D


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
func _ready() -> void:
	collision_shape.disabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if (body.current_state is JetBoardMovingState or 
		body.current_state is JetBoardBoostState or
		body.current_state is JetBoardIdleState):
			collision_shape.set_deferred("disabled", false)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		collision_shape.set_deferred("disabled", true)
