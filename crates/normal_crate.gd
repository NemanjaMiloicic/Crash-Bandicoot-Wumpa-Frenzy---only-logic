class_name NormalCrate
extends StaticBody2D

var broken = false
var hit_top = INF
var hit_bottom = 1 
var animation := "broken_crate"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var broken_crate: AudioStreamPlayer = $BrokenCrate
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var drop_scene
func _ready() -> void:
	if GameManager.collected_crates.has(global_position):	
		queue_free()
	drop_scene = load("res://scenes/collectibles/wumpa_fruit.tscn")
	


func _on_crate_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		body.near_crates.append(self)


func _on_crate_body_exited(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		body.near_crates.erase(self)

func destroy(near_crates):
	if broken:
		return
	if self in near_crates:
		near_crates.erase(self)
	
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.visible = false
	if animation:
		animated_sprite_2d.visible = true
		animated_sprite_2d.play(animation)
	broken = true
	GameManager.currently_collected_crates.append(global_position)
	if is_in_group('exploding_crate'):
		print('to do')
	else:
		broken_crate.play()
	if ray_cast_2d.is_colliding() and animation:
		var collision_point = ray_cast_2d.get_collision_point()
		var distance = global_position.distance_to(collision_point)
		if distance > 7:  
			animated_sprite_2d.visible = false
	else:
		animated_sprite_2d.visible = false
	if drop_scene: 	
		var drop = drop_scene.instantiate()
		drop.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", drop)


	


func _on_top_body_entered(body: Node2D) -> void:
	if broken:
		return
	
	bounce_of_crate(body , true)


func _on_bottom_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("player"):
		if global_position.y < body.global_position.y and not body.attacking and body.current_state is JumpState: 
			body.animated_sprite.play("jump")
			body.move_and_slide()
			destroy(body.near_crates)
			GameManager.add_crates()

func bounce_of_crate(body : Node2D , counted : bool) -> void:
	if body.is_in_group("player"):
		if global_position.y > body.global_position.y and not body.attacking and body.current_state is JumpState:
			body.animated_sprite.play("jump")
			if not body.slid_jumped:
				body.velocity.y = body.JUMP_VELOCITY - 40
			else:
				body.velocity.y = body.JUMP_VELOCITY + 20 
			body.move_and_slide()
			if counted:
				destroy(body.near_crates)
				GameManager.add_crates()
