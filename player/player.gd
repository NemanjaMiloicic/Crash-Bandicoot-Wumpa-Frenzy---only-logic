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
@onready var victory_stream_player_2d: AudioStreamPlayer2D = $VictoryStreamPlayer2D
@onready var hit_ground_stream_player_2d: AudioStreamPlayer2D = $HitGroundStreamPlayer2D
@onready var spin_stream_player_2d: AudioStreamPlayer2D = $SpinStreamPlayer2D
@onready var slide_stream_player_2d: AudioStreamPlayer2D = $SlideStreamPlayer2D
@onready var run_stream_player_2d: AudioStreamPlayer2D = $RunStreamPlayer2D
@onready var jump_stream_player_2d: AudioStreamPlayer2D = $JumpStreamPlayer2D
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

var current_state : State = null
var previous_state : State = null
var states = {}

func _ready() -> void:
	run_stream_player_2d.stream.loop = true
	states["IdleState"] = IdleState.new()
	states["RunState"] = RunState.new()
	states["JumpState"] = JumpState.new()
	states["DeadState"] = DeadState.new()
	states["VictoryState"] = VictoryState.new()
	states["SpinState"] = SpinState.new()
	states["SlideState"] = SlideState.new()
	states["BellyFlopState"] = BellyFlopState.new()
	states["HitGroundState"] = HitGroundState.new()
	states["CrouchState"] = CrouchState.new()
	states["CrawlState"] = CrawlState.new()
	for state in states.values():
		state.state_owner = self
	
	current_state = states["IdleState"]
	current_state.enter()

func _physics_process(delta: float) -> void:
	
	if current_state:
		current_state.physics_update(delta)
		
	# Move the character after velocity is updated in the state
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	current_state.on_animation_finished()

	


func _on_spin_cooldown_timeout() -> void:
	can_spin = true

func check_direction(direction):
		if direction == 1:
			facing_right = 1 
		else:
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
	collision_shape_2d.shape.height -= SLIDE_HEIGHT_REDUCTION
	collision_shape_2d.position.y += SLIDE_HEIGHT_REDUCTION / 2.0

func restore_collider():
	collision_shape_2d.shape.height += SLIDE_HEIGHT_REDUCTION
	collision_shape_2d.position.y -= SLIDE_HEIGHT_REDUCTION / 2.0
