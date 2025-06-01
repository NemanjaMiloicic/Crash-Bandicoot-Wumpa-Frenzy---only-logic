class_name CheckpointCrate
extends NormalCrate

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	super._ready()
	animation = "broken_checkpoint"
	drop_scene = null

func destroy(near_crates) -> void:
	super.destroy(near_crates)
	GameManager.checkpoint_hit()
	GameManager.player_position = global_position
	audio_stream_player.play()
	
