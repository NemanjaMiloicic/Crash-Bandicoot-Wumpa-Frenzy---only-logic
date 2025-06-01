extends Node

var current_level : Node
@onready var hud: CanvasLayer = $Hud

func _ready():
	load_level("res://scenes/levels/level1.tscn") 
	
func load_level(path : String):
	GameManager.check_for_checkpoint()
	if current_level:
		current_level.queue_free()
	var level_scene = load(path)
	current_level = level_scene.instantiate()
	current_level.connect("ready", Callable(self, "_on_level_ready"))
	add_child(current_level)
	
func _on_level_ready():
	GameManager.set_current_level(current_level, hud)
	
