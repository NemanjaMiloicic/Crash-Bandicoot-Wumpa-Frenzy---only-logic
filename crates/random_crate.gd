class_name RandomCrate
extends NormalCrate

func _ready() -> void:
	super._ready()
	var wumpa_scene = preload("res://scenes/collectibles/wumpa_fruit_x_5.tscn")
	var life_scene = preload("res://scenes/collectibles/life.tscn")
	var aku_aku_scene = preload("res://scenes/power_ups/aku_aku_power_up.tscn")
	
	var rand = randi() % 100
	
	if rand < 96:
		drop_scene = wumpa_scene
	elif rand < 99:
		drop_scene = life_scene
	else:
		drop_scene = aku_aku_scene
