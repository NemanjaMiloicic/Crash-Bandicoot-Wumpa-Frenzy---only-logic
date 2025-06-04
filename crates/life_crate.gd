class_name LifeCrate
extends NormalCrate

var replace = true

func _ready() -> void:
	super._ready()
	drop_scene = preload("res://scenes/collectibles/life.tscn")
	if GameManager.used_life_crates.has(global_position):
		queue_free()
func destroy(near_crates) -> void:
	super.destroy(near_crates)
	if replace:
		GameManager.used_life_crates.append(global_position)
	
