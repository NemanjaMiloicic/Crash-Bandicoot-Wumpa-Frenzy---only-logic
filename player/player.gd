class_name  Player
extends CharacterBody2D

const SPEED = 115.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#timers
@onready var spin_cooldown: Timer = $SpinCooldown
@onready var slide_cooldown: Timer = $SlideCooldown
@onready var slide_leniency: Timer = $SlideLeniency
#audio
@onready var death_stream_player_2d: AudioStreamPlayer2D = $Sounds/DeathStreamPlayer2D
@onready var swinging_stream_player_2d: AudioStreamPlayer2D = $Sounds/SwingingStreamPlayer2D
@onready var fly_stream_player_2d: AudioStreamPlayer2D = $Sounds/FlyStreamPlayer2D
@onready var jump_stream_player_2d: AudioStreamPlayer2D = $Sounds/JumpStreamPlayer2D
@onready var run_stream_player_2d: AudioStreamPlayer2D = $Sounds/RunStreamPlayer2D
@onready var slide_stream_player_2d: AudioStreamPlayer2D = $Sounds/SlideStreamPlayer2D
@onready var hit_ground_stream_player_2d: AudioStreamPlayer2D = $Sounds/HitGroundStreamPlayer2D
@onready var spin_stream_player_2d: AudioStreamPlayer2D = $Sounds/SpinStreamPlayer2D
@onready var victory_stream_player_2d: AudioStreamPlayer2D = $Sounds/VictoryStreamPlayer2D
@onready var fire_death_stream_player_2d: AudioStreamPlayer2D = $Sounds/FireDeathStreamPlayer2D
@onready var blink_stream_player_2d: AudioStreamPlayer2D = $Sounds/BlinkStreamPlayer2D
@onready var electric_death_stream_player_2d: AudioStreamPlayer2D = $Sounds/ElectricDeathStreamPlayer2D


#ceiling check
@onready var ceiling_check_area_2d: Area2D = $CeilingCheckArea2D

const SLIDE_HEIGHT_REDUCTION = 10
const SLIDE_JUMP_BOOST = -4

var got_crystal := false 
var can_spin := true
var can_slide := true
var near_crates = []
var facing_right := 1
var jump_pressed := false
var slide_jump = false
var slide_collision_reset = false
var old_collision_shape
var old_collision_position

var current_state : State = null
var previous_state : State = null
var states = {}

#death_states
var electricity := false
var fire := false

func _ready() -> void:
	run_stream_player_2d.stream.loop = true
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
	states["FlyState"] = FlyState.new(self)
	#Hanging_states
	states["HangingState"] = HangingState.new(self)
	states["SwingState"] = SwingState.new(self)
	states["HangSpinState"] = HangSpinState.new(self)
	
	current_state = states["IdleState"]
	current_state.enter()

func _physics_process(delta: float) -> void:
	
	if current_state:
		current_state.physics_update(delta)
	# only restore collider if there isnt any obstacle
	if slide_collision_reset:
		try_restore_collider()
	
	# move after velocity changes
	check_direction()
	move_and_slide()
	


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
			crate.destroy()
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
