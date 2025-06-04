extends Node

var wumpas := 0
var crates := 0
var lives := 4
var total_crates_in_level := 0
var hud : Node
var current_level : Node
var used_life_crates = []
var collected_crates = []
var activated_switches = []
var currently_activated_switches = []
var aku_protection :=0
var timer
const MAX_AKU := 3
const MAX_WUMPAS_LIVES := 99
var play_back_pos
var invincibility_ran_out := false
var checkpoint_just_hit := false
var num_collected_crates := 0
var currently_collected_crates = []
var player_position = null
var currently_collected_gems = []
var collected_gems = []
var collected_invisible_life = []

@onready var max_aku_state: Timer = $MaxAkuState
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var music: AudioStreamPlayer = $Music
@onready var invincibility_music: AudioStreamPlayer = $InvincibilityMusic


func set_current_level(level: Node , p_hud : Node) -> void:
	currently_collected_crates.clear()
	randomize()
	current_level = level
	total_crates_in_level = count_boxes_in_level()
	hud = p_hud
	hud.update_hud(wumpas, crates, total_crates_in_level, lives)
	respawn_life_crates_as_normal()
	set_player_position()

func count_boxes_in_level() -> int:
	var crates_node = current_level.get_node("Crates")
	var count = 0

	for child in crates_node.get_children():
		if child.is_in_group("metal_crate"):
			for metal_child in child.get_children():
				if metal_child.is_in_group("crates") and not metal_child.is_in_group("metal_crate"):
					count += 1
		else:
			if child.is_in_group("crates"):
				count += 1

	return count



func add_wumpas() -> void:
	if wumpas == MAX_WUMPAS_LIVES:
		wumpas = 0
		add_life_with_wumpas()
	else:
		wumpas += 1
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)

func add_crates() -> void:
	crates += 1
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)
	
func add_life_with_wumpas() -> void:
	if lives == MAX_WUMPAS_LIVES:
		lives = MAX_WUMPAS_LIVES
	else:
		lives += 1
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)

func add_life() -> void:
	if lives == MAX_WUMPAS_LIVES:
		lives = MAX_WUMPAS_LIVES
	else:
		lives += 1
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)

func die() -> void:
	if lives == 0:
		collected_crates = []
		collected_gems = []
		used_life_crates = []
		activated_switches = []
		collected_invisible_life = []
		player_position = null
		wumpas = 0
		num_collected_crates = 0
		crates = 0
		#to-do
		lives = 4
	else:
		lives -= 1
	crates = 0
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)
	
func got_gem() -> bool:
	if crates == total_crates_in_level:
		return true
	return false
	
func got_aku() -> void:
	if aku_protection == MAX_AKU-1:
		max_aku() 
	if aku_protection<MAX_AKU:
		aku_protection+=1
	
		
		
func killed() -> bool:
	if aku_protection == 0:
		return true
	elif aku_protection != MAX_AKU or invincibility_ran_out:
		invincibility_ran_out = false
		hit_sound.play()
		aku_protection-=1
	
	
	return false

func instant_kill() -> void:
	if not max_aku_state.is_stopped():
		max_aku_state.stop()
	if invincibility_music.playing:
		invincibility_music.stop()
		music.play(play_back_pos)
	aku_protection = 0

func max_aku() -> void:
	
	max_aku_state.start()
	play_back_pos =music.get_playback_position()
	music.stop()
	invincibility_music.play()

func _on_max_aku_state_timeout() -> void:
	invincibility_ran_out = true
	killed()
	


func _on_invincibility_music_finished() -> void:
	music.play(play_back_pos)
	
func check_max_aku() -> bool:
	return aku_protection == MAX_AKU

func respawn_life_crates_as_normal():
	var normal_crate_scene = preload("res://scenes/crates/normal_crate.tscn")
	
	for pos in used_life_crates:
		var crate = normal_crate_scene.instantiate()
		crate.global_position = pos
		get_tree().current_scene.add_child(crate)

func checkpoint_hit() -> void:
	checkpoint_just_hit = true
	num_collected_crates = crates+1
	collected_crates.append_array(currently_collected_crates)
	collected_gems.append_array(currently_collected_gems)
	activated_switches.append_array(currently_activated_switches)
	
func check_for_checkpoint() -> void:
	crates = num_collected_crates
	checkpoint_just_hit = false

func set_player_position() -> void:
	if player_position:
		var player = current_level.get_node("CharacterBody2D")
		var camera = player.get_node("Camera2D")
		if player:
			player.position = player_position
			camera.position_smoothing_enabled = false
			camera.reset_smoothing()
			camera.global_position = player_position
			camera.position_smoothing_enabled = true
			camera.reset_smoothing()
