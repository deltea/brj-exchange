extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var run_speed = 120.0
@export var dash_speed = 400.0
@export var dash_time = 0.16
@export var dash_cooldown = 0.4

@export_category("Shooting")
@export var bullet_speed = 800.0
@export var fire_rate = 8.0
@export var spread = 5.0
@export var bullet_size = 1.0
@export var bullet_damage = 1.0

@export_category("Health")
@export var max_health = 100
@export var regen = 1

@export_category("Animation")
@export var squash_and_stretch = 0.2
@export var turn_speed = 20
@export var squash_and_stretch_speed = 50

@onready var sprite := $Sprite
@onready var dash_timer := $DashTimer
@onready var dash_cooldown_timer := $DashCooldownTimer
@onready var move_particles := $MoveParticles
@onready var hitbox := $Hitbox

var target_rotation = 0.0
var target_scale = Vector2.ONE
var next_time_to_fire = 0.0
var health = max_health
var bullet_scene = preload("res://player_bullet.tscn")
var wind_force = Vector2.ZERO
var can_move = true

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = dash_time
	dash_cooldown_timer.wait_time = dash_cooldown
	hitbox.set_collision_mask_value(4, true)
	Events.go_in_portal.connect(_on_go_into_portal)

func _process(delta: float) -> void:
	if not can_move: return

	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, turn_speed * delta)
	sprite.scale = sprite.scale.move_toward(target_scale, squash_and_stretch_speed * delta)

func _physics_process(_delta: float) -> void:
	if not can_move: return

	var input = Input.get_vector("left", "right", "up", "down")

	if input:
		target_scale = Vector2.ONE + Vector2(squash_and_stretch, -squash_and_stretch)
		target_rotation = input.angle()
	else:
		target_scale = Vector2.ONE

	var speed = dash_speed if is_dashing() else run_speed
	velocity = input * speed + wind_force

	if Input.is_action_just_pressed("dash") and can_dash():
		dash()

	if Input.is_action_pressed("fire") and Globals.time >= next_time_to_fire:
		fire()

	move_and_slide()

func fire():
	next_time_to_fire = Globals.time + 1.0 / fire_rate
	Globals.mouse.impact_rotation()

	var bullet = bullet_scene.instantiate() as PlayerBullet
	var mouse_pos = get_global_mouse_position()
	bullet.global_position = global_position + ((mouse_pos - global_position).normalized() * 12)
	bullet.look_at(mouse_pos)
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.scale = Vector2.ONE * bullet_size
	bullet.speed = bullet_speed

	Globals.world.add_child(bullet)

func dash():
	dash_timer.start()
	dash_cooldown_timer.start()
	move_particles.emitting = false
	hitbox.set_collision_mask_value(4, false)

func is_dashing() -> bool:
	return not dash_timer.is_stopped()

func can_dash():
	return dash_cooldown_timer.is_stopped()

func get_hurt(damage: float):
	print("oof")
	health -= damage
	Globals.hitstop(0.15)
	Globals.camera.impact()
	Globals.camera.shake(0.1, 1)
	if health <= 0:
		die()
		return

func die():
	print("ur ded")
	Globals.hitstop(10000)

func _on_go_into_portal(portal: Portal):
	can_move = false
	velocity = Vector2.ZERO
	move_particles.emitting = false
	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(sprite, "scale", Vector2.ZERO, 1)
	tweener.tween_property(sprite, "global_position", portal.position, 1)
	tweener.tween_property(sprite, "global_rotation_degrees", sprite.global_rotation_degrees + 360, 1)
	tweener.tween_callback(func(): SceneManager.change_scene(SceneManager.exchange_scene)).set_delay(1)

func _on_dash_timer_timeout() -> void:
	move_particles.emitting = true
	hitbox.set_collision_mask_value(4, true)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is EnemyBullet:
		var bullet = area as EnemyBullet
		bullet.queue_free()
		get_hurt(bullet.damage)
	elif area is EnemyTile:
		var tile = area as EnemyTile
		tile.queue_free()
		get_hurt(tile.damage)
