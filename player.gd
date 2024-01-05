extends CharacterBody2D
class_name Player

@export var run_speed = 60
@export var dash_speed = 200
@export var dash_time = 0.2
@export var dash_cooldown = 1.0

@export_category("Animation")
@export var tilt = 10
@export var dash_ghost_delay = 0.02
@export var dash_ghost_duration = 0.3

@onready var sprite := $Sprite
@onready var dash_timer := $DashTimer

var ghost_scene = preload("res://dash_ghost.tscn")
var dash_ghost_timer = 0

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = dash_time

func _process(delta: float) -> void:
	dash_ghost_timer += delta
	if dash_ghost_timer >= dash_ghost_delay and is_dashing():
		dash_ghost_timer = 0
		instance_ghost()

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")

	sprite.rotation_degrees = input.x * tilt
	if input:
		sprite.play("run")
	else:
		sprite.stop()

	var speed = dash_speed if is_dashing() else run_speed
	velocity = input * speed

	if Input.is_action_just_pressed("dash"):
		dash_timer.start()

	move_and_slide()

func instance_ghost():
	var ghost = ghost_scene.instantiate() as DashGhost

	ghost.global_position = global_position
	ghost.duration = dash_ghost_duration

	get_parent().get_parent().add_child(ghost)

func is_dashing() -> bool:
	return not dash_timer.is_stopped()
