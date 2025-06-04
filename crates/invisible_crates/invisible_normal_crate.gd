class_name InvisibleNormalCrate
extends Sprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var crate
var path = "res://scenes/crates/"
var crate_scene = "normal_crate.tscn"


func _ready() -> void:
	path+=crate_scene
	crate = load(path)

func activate() -> void:
	visible = false
	var new_crate = crate.instantiate()
	if new_crate is LifeCrate:
		new_crate.replace = false
	new_crate.global_position = global_position 
	get_tree().current_scene.call_deferred("add_child", new_crate)
	audio_stream_player_2d.play()
	


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
