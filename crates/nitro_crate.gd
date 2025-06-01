class_name NitroCrate
extends NormalCrate


var base_y := 0.0
var bounce_timer := 0.0
var bounce_interval := 5.0 
var is_jumping:= false
var jump_height := -20.0 
var fall_speed := 50.0 
var current_velocity := 0.0
@onready var jump: AudioStreamPlayer2D = $Jump


func _ready() -> void:
	super._ready()
	drop_scene = load("res://scenes/hazards/nitro_explosion.tscn")
	animation = ''
	base_y = position.y
	
	
func _physics_process(delta: float) -> void:
	if broken:
		return

	if is_jumping:
		current_velocity += fall_speed * delta
		position.y += current_velocity * delta
		
		if position.y >= base_y:
			position.y = base_y
			is_jumping = false

func destroy(near_crates) -> void:
	super.destroy(near_crates)

func _on_crate_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not broken:
		body.near_crates.append(self)
		destroy(body.near_crates)
		GameManager.add_crates()
		broken = true

func _on_top_body_entered(body: Node2D) -> void:
	if not broken:
		bounce_of_crate(body , true)
	

func _on_bottom_body_entered(_body: Node2D) -> void:
	pass

func explode():
	if not broken:
		GameManager.add_crates()
		queue_free()
		broken = true


func _on_bounce_timer_timeout() -> void:
	if not broken:
		jump.play()
		current_velocity = jump_height
		is_jumping = true
