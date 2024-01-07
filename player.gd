extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var run_speed = 60
@export var dash_speed = 300
@export var dash_time = 0.15

@export_category("Shooting")
@export var bullet_speed = 700
@export var fire_rate = 3.0
@export var spread = 10
@export var bullet_size = 1

@export_category("Animation")
@export var squash_and_stretch = 0.2
@export var turn_speed = 20
@export var squash_and_stretch_speed = 50

@onready var sprite := $Sprite
@onready var dash_timer := $DashTimer

var target_rotation = 0.0
var target_scale = Vector2.ONE
var next_time_to_fire = 0.0
var bullet_scene = preload("res://player_bullet.tscn")

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = dash_time

func _process(delta: float) -> void:
	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, turn_speed * delta)
	sprite.scale = sprite.scale.move_toward(target_scale, squash_and_stretch_speed * delta)

func _physics_process(_delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("dash"):
		dash_timer.start()

	if input:
		target_scale = Vector2.ONE + Vector2(squash_and_stretch, -squash_and_stretch)
		target_rotation = input.angle()
	else:
		target_scale = Vector2.ONE

	var speed = dash_speed if is_dashing() else run_speed
	velocity = input * speed

	if Input.is_action_pressed("fire") and Globals.time >= next_time_to_fire:
		fire()

	move_and_slide()

func fire():
	next_time_to_fire = Globals.time + 1 / fire_rate

	var bullet = bullet_scene.instantiate() as PlayerBullet
	bullet.global_position = global_position
	bullet.look_at(get_global_mouse_position())
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.scale = Vector2.ONE * bullet_size
	bullet.speed = bullet_speed

	Globals.world.add_child(bullet)

func is_dashing() -> bool:
	return not dash_timer.is_stopped()
