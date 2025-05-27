extends Node

var wumpas := 0
var crates := 0
var lives := 4
var total_crates_in_level := 0
var hud : Node
var current_level : Node
var collected_lives = []
var aku_protection :=0
var timer
const MAX_AKU := 3
const MAX_WUMPAS_LIVES := 99
var play_back_pos
var invincibility_ran_out := false

@onready var max_aku_state: Timer = $MaxAkuState
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var music: AudioStreamPlayer = $Music
@onready var invincibility_music: AudioStreamPlayer = $InvincibilityMusic


func set_current_level(level: Node , p_hud : Node) -> void:
	current_level = level
	total_crates_in_level = count_boxes_in_level()
	hud = p_hud
	hud.update_hud(wumpas, crates, total_crates_in_level, lives)

func count_boxes_in_level() -> int:
	var crates_node = current_level.get_node("Crates")
	return crates_node.get_child_count()
	
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

func add_life(global_position : Vector2) -> void:
	collected_lives.append(global_position)
	if lives == MAX_WUMPAS_LIVES:
		lives = MAX_WUMPAS_LIVES
	else:
		lives += 1
	hud.update_hud(wumpas , crates , total_crates_in_level , lives)

func die() -> void:
	if lives == 0:
		print("Game over!")
		#to-do
		lives = 4
	else:
		lives -= 1
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
