class_name InvisibleLifeCrate
extends InvisibleNormalCrate


func _ready() -> void:
	if GameManager.collected_invisible_life.has(global_position):
		crate_scene = "normal_crate.tscn"
	else:
		crate_scene = "life_crate.tscn"
	super._ready()
	
func activate() -> void:
	super.activate()
	GameManager.collected_invisible_life.append(global_position)
