extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var dash_cooldown = 0.4

@export_category("Shooting")
@export var fire_rate = 8.0
@export var spread = 5.0
@export var bullet_damage = 1.0

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
var health: float
var bullet_scene = preload("res://player_bullet.tscn")
var wind_force = Vector2.ZERO
var can_move = true
var whirlpool_force = 0

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = Stats.dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	hitbox.set_collision_mask_value(4, true)
	Events.go_in_portal.connect(_on_go_into_portal)
	scale = Stats.player_size * Vector2.ONE
	health = Stats.max_health

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

	var speed = Stats.dash_speed if is_dashing() else Stats.run_speed
	var whirlpool = (Vector2.ZERO - position).normalized() * whirlpool_force
	velocity = input * speed + wind_force + whirlpool

	if Input.is_action_just_pressed("dash") and can_dash():
		dash()

	if Input.is_action_pressed("fire") and Globals.time >= next_time_to_fire:
		fire()

	move_and_slide()

func fire():
	next_time_to_fire = Globals.time + 1.0 / fire_rate
	Globals.mouse.impact_rotation()
	AudioManager.play_sound(AudioManager.shoot)

	var bullet = bullet_scene.instantiate() as PlayerBullet
	var mouse_pos = get_global_mouse_position()
	bullet.global_position = global_position + ((mouse_pos - global_position).normalized() * 12)
	bullet.look_at(mouse_pos)
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.scale = Vector2.ONE * Stats.bullet_size
	bullet.speed = Stats.bullet_speed

	Globals.world.add_child(bullet)

func dash():
	dash_timer.start()
	dash_cooldown_timer.start()
	move_particles.emitting = false
	hitbox.set_collision_mask_value(4, false)
	hitbox.set_collision_mask_value(3, false)

func is_dashing() -> bool:
	return not dash_timer.is_stopped()

func can_dash():
	return dash_cooldown_timer.is_stopped()

func get_hurt(damage: float):
	AudioManager.play_sound(AudioManager.hurt)
	health -= damage
	update_health_ui()
	Globals.hitstop(0.15)
	Globals.camera.impact()
	Globals.camera.shake(0.1, 1)
	if health <= 0:
		die()
		return

func die():
	print("ur ded")
	Globals.hitstop(10000)

func update_health_ui():
	Globals.canvas.player_health.value = 100.0 / Stats.max_health * health

func change_to_next_scene():
	if Globals.world.name == "Level 4":
		SceneManager.change_scene(SceneManager.win_scene)
	else:
		SceneManager.change_scene(SceneManager.exchange_scene)

func _on_go_into_portal(portal: Portal):
	can_move = false
	velocity = Vector2.ZERO
	move_particles.emitting = false
	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(sprite, "scale", Vector2.ZERO, 1)
	tweener.tween_property(sprite, "global_position", portal.position, 1)
	tweener.tween_property(sprite, "global_rotation_degrees", sprite.global_rotation_degrees + 360, 1)
	tweener.tween_callback(change_to_next_scene).set_delay(1)

func _on_dash_timer_timeout() -> void:
	move_particles.emitting = true
	hitbox.set_collision_mask_value(4, true)
	hitbox.set_collision_mask_value(3, true)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is EnemyBullet or area is Fish:
		area.queue_free()
		get_hurt(Stats.enemy_damage)
	elif area is Rock or area is EnemyTile:
		get_hurt(Stats.enemy_damage)

func _on_regen_timer_timeout() -> void:
	health += Stats.regen
	update_health_ui()
