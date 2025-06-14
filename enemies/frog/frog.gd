extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_area: Area2D = $HitboxArea
@onready var enemy_area: Area2D = $EnemyArea
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox_shape_2d: CollisionShape2D = $HitboxArea/CollisionShape2D
@onready var death_timer: Timer = $DeathTimer
@onready var spin_death_sound: AudioStreamPlayer = $SpinDeathSound
@onready var bounce_death_sound: AudioStreamPlayer = $BounceDeathSound



var states = {}
var current_state : State
var previous_state : State
var direction := 1 
var can_move := false
var can_jump := true
var is_jumping := false
var player
var is_dead := false
var knockback_direction = 1
var spun := false
const BOUNCE := 60
const KNOCKBACK := 400
const JUMP_FORCE := -250
const SPEED := 50

func _ready():
	states["WanderingState"] = WanderingFrogState.new(self)
	states["ChasingState"] = ChasingFrogState.new(self)

	current_state = states["WanderingState"]
	current_state.enter()
	

func _physics_process(delta):
	if is_dead:
		if spun:
			velocity.x += knockback_direction * KNOCKBACK 
			move_and_slide()
			return
		else:
			animated_sprite_2d.visible = false  
	if current_state:
		current_state.physics_update(delta)
	move_and_slide()



func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		current_state.change_state("ChasingState")


func _on_enemy_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_state.change_state("WanderingState")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "stand":
		velocity.y = JUMP_FORCE
		animated_sprite_2d.play("jump")
		can_jump = true
		can_move = true
		is_jumping = true
	elif animated_sprite_2d.animation == "jump":
		is_jumping = false

func die() -> void:
	is_dead = true
	current_state.exit()
	animated_sprite_2d.play("jump")
	collision_shape_2d.set_deferred("disabled" , true)
	death_timer.start()

func die_by_bounce() -> void:
	bounce_death_sound.play()
	die()

func die_by_hit(body : Node2D) -> void:
	spin_death_sound.play()
	knockback_direction = body.facing_right
	die()


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_head_area_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	if not body.is_in_group("player"):
		return
	
	is_dead = true
	
	if body.current_state is BellyFlopState:
		die_by_bounce()
	elif body.current_state is JumpState:
		if body.slid_jumped:
			body.velocity.y = body.JUMP_VELOCITY 
		else:
			body.velocity.y = body.JUMP_VELOCITY - BOUNCE
		die_by_bounce()
