class_name ExclamationCrate
extends NitroDetonator
@onready var timer: Timer = $Timer

func _ready() -> void:
	if GameManager.activated_switches.has(global_position):
		activate()

func activate() -> void:
	if activated:
		return
	activated = true
	sprite_2d.visible = false
	activated_sprite_2d.visible = true
	broken_crate.play()
	for node in get_children():
		if node.is_in_group("crates"):
			timer.start()
			node.activate()
			await timer.timeout
	GameManager.currently_activated_switches.append(global_position)
