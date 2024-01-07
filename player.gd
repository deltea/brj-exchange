extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var run_speed = 60.0
@export var dash_speed = 300.0
@export var dash_time = 0.15
@export var dash_cooldown = 0.5

@export_category("Shooting")
@export var bullet_speed = 800.0
@export var fire_rate = 8.0
@export var spread = 5.0
@export var bullet_size = 1.0

@export_category("Animation")
@export var squash_and_stretch = 0.2
@export var turn_speed = 20
@export var squash_and_stretch_speed = 50

@onready var sprite := $Sprite
@onready var dash_timer := $DashTimer
@onready var dash_cooldown_timer := $DashCooldownTimer

var target_rotation = 0.0
var target_scale = Vector2.ONE
var next_time_to_fire = 0.0
var bullet_scene = preload("res://player_bullet.tscn")

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = dash_time
	dash_cooldown_timer.wait_time = dash_cooldown

func _process(delta: float) -> void:
	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, turn_speed * delta)
	sprite.scale = sprite.scale.move_toward(target_scale, squash_and_stretch_speed * delta)

func _physics_process(_delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("dash") and can_dash():
		dash_timer.start()
		dash_cooldown_timer.start()

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
	next_time_to_fire = Globals.time + 1.0 / fire_rate

	var bullet = bullet_scene.instantiate() as PlayerBullet
	var mouse_pos = get_global_mouse_position()
	bullet.global_position = global_position + ((mouse_pos - global_position).normalized() * 5)
	bullet.look_at(mouse_pos)
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.scale = Vector2.ONE * bullet_size
	bullet.speed = bullet_speed

	Globals.world.add_child(bullet)

func is_dashing() -> bool:
	return not dash_timer.is_stopped()

func can_dash():
	return dash_cooldown_timer.is_stopped()
