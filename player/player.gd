class_name  Player
extends CharacterBody2D

const SPEED = 115.0
const MAX_AKU_SPEED = 150.0
const JUMP_VELOCITY = -300.0
var speed = SPEED


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var aku_aku_sprite_2d: AnimatedSprite2D = $AkuAkuSprite2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#timers
@onready var spin_cooldown: Timer = $SpinCooldown
@onready var slide_cooldown: Timer = $SlideCooldown
@onready var slide_leniency: Timer = $SlideLeniency
@onready var invincibility_time: Timer = $InvincibilityTime

#audio
@onready var death_stream_player: AudioStreamPlayer = $Sounds/DeathStreamPlayer
@onready var swinging_stream_player: AudioStreamPlayer = $Sounds/SwingingStreamPlayer
@onready var fly_stream_player: AudioStreamPlayer = $Sounds/FlyStreamPlayer
@onready var jump_stream_player: AudioStreamPlayer = $Sounds/JumpStreamPlayer
@onready var run_stream_player: AudioStreamPlayer = $Sounds/RunStreamPlayer
@onready var slide_stream_player: AudioStreamPlayer = $Sounds/SlideStreamPlayer
@onready var hit_ground_stream_player: AudioStreamPlayer = $Sounds/HitGroundStreamPlayer
@onready var spin_stream_player: AudioStreamPlayer = $Sounds/SpinStreamPlayer
@onready var victory_stream_player: AudioStreamPlayer = $Sounds/VictoryStreamPlayer
@onready var fire_death_stream_player: AudioStreamPlayer = $Sounds/FireDeathStreamPlayer
@onready var blink_stream_player: AudioStreamPlayer = $Sounds/BlinkStreamPlayer
@onready var electric_death_stream_player: AudioStreamPlayer = $Sounds/ElectricDeathStreamPlayer
@onready var speed_stream_player: AudioStreamPlayer = $Sounds/SpeedStreamPlayer
@onready var pogo_stream_player: AudioStreamPlayer = $Sounds/PogoStreamPlayer

#animations
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var aku_animation: AnimationPlayer = $AkuAnimation

#ceiling check
@onready var ceiling_check_area_2d: Area2D = $CeilingCheckArea2D

const SLIDE_HEIGHT_REDUCTION = 10
const SLIDE_JUMP_BOOST = -4
const AKU_SPEED = 10
var got_crystal := false 
var can_spin := true
var can_slide := true
var near_crates = []
var facing_right := 1
var jump_pressed := false
var slide_jump = false
var slide_collision_reset = false
var attacking := false
var slid_jumped := false
var old_collision_shape
var old_collision_position

var current_state : State = null
var previous_state : State = null
var states = {}

var AKU_POSITION_LEFT = Vector2(20 , -30)
var AKU_POSITION_RIGHT = Vector2(-20 , -30)
var MAX_AKU_POSITION_LEFT = Vector2(6,-20)
var MAX_AKU_POSITION_RIGHT = Vector2(-6,-20)
var aku_target_position = Vector2.ZERO

#death_states
var death = DeathState.DEFAULT

var bobbing_animation = false

func _ready() -> void:
	run_stream_player.stream.loop = true
	old_collision_shape = collision_shape_2d.shape.height
	old_collision_position = collision_shape_2d.position.y
	#Normal_states
	states["IdleState"] = IdleState.new(self)
	states["RunState"] = RunState.new(self)
	states["JumpState"] = JumpState.new(self)
	states["DeadState"] = DeadState.new(self)
	states["VictoryState"] = VictoryState.new(self)
	states["SpinState"] = SpinState.new(self)
	states["SlideState"] = SlideState.new(self)
	states["BellyFlopState"] = BellyFlopState.new(self)
	states["HitGroundState"] = HitGroundState.new(self)
	states["CrouchState"] = CrouchState.new(self)
	states["CrawlState"] = CrawlState.new(self)
	#Hanging_states
	states["HangingState"] = HangingState.new(self)
	states["SwingState"] = SwingState.new(self)
	states["HangSpinState"] = HangSpinState.new(self)
	#Power_Up_States
	states["FlyState"] = FlyState.new(self)
	states["RocketState"] = RocketState.new(self)
	states["PogoState"] = PogoState.new(self)
	
	current_state = states["IdleState"]
	current_state.enter()

func _physics_process(delta: float) -> void:
	
	if GameManager.aku_protection == GameManager.MAX_AKU:
		animation_player.play("flash")
		destroy_crates()
		speed = MAX_AKU_SPEED
	else:
		speed = SPEED
	
	if current_state:
		current_state.physics_update(delta)
	# only restore collider if there isnt any obstacle
	if slide_collision_reset:
		try_restore_collider()
	
	# move after velocity changes
	check_direction()	
	move_and_slide()
	prepare_aku()
	move_aku(delta)
	check_for_bobbing()
	

func _on_animated_sprite_2d_animation_finished() -> void:
	current_state.on_animation_finished()

func _on_spin_cooldown_timeout() -> void:
	can_spin = true

func check_direction():
	var input = Input.get_axis("move_left" , "move_right")
	if input > 0:
		facing_right = 1
	elif input < 0:
		facing_right = -1
		
func _on_slide_cooldown_timeout() -> void:
	can_slide = true
	
func destroy_crates() -> void:
	if near_crates.size()>0:
		for crate in near_crates:
			crate.destroy(near_crates)
			GameManager.currently_collected_crates.append(crate.global_position)
			GameManager.add_crates()
		near_crates.clear()

func can_stand_up() -> bool:
	return ceiling_check_area_2d.get_overlapping_bodies().is_empty()
	
func shrink_collider():
		collision_shape_2d.shape.height = old_collision_shape -SLIDE_HEIGHT_REDUCTION
		collision_shape_2d.position.y = old_collision_position +SLIDE_HEIGHT_REDUCTION / 2.0
		
func restore_collider():
	collision_shape_2d.shape.height = old_collision_shape
	collision_shape_2d.position.y = old_collision_position 
	
func try_restore_collider():
	if can_stand_up():
		restore_collider()
		slide_collision_reset = false


func _on_speed_stream_player_finished() -> void:
	speed_stream_player.play_with_random_pitch()

func prepare_aku():
	if GameManager.aku_protection == 0:
		aku_aku_sprite_2d.play('not_here')
	elif GameManager.aku_protection == 1:
		aku_aku_sprite_2d.play("float")
	elif GameManager.aku_protection == 2:
		aku_aku_sprite_2d.play("gold_float")
	elif GameManager.aku_protection == GameManager.MAX_AKU:
		aku_animation.stop()
		aku_aku_sprite_2d.play("max_aku_float")
	# Flip
	if facing_right == 1:
		aku_aku_sprite_2d.flip_h = false
		aku_target_position = AKU_POSITION_RIGHT if GameManager.aku_protection != GameManager.MAX_AKU else MAX_AKU_POSITION_LEFT
	else:
		aku_aku_sprite_2d.flip_h = true
		aku_target_position = AKU_POSITION_LEFT if GameManager.aku_protection != GameManager.MAX_AKU else MAX_AKU_POSITION_RIGHT

func move_aku(delta):
	aku_aku_sprite_2d.position = aku_aku_sprite_2d.position.lerp(aku_target_position, delta * AKU_SPEED)

func check_for_bobbing():
	if GameManager.check_max_aku():
		bobbing_animation = true
	
	if bobbing_animation and GameManager.aku_protection == GameManager.MAX_AKU-1:
		aku_animation.play()
		bobbing_animation = false
