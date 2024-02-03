extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var dash_cooldown = 0.4

@export_category("Animation")
@export var squash_and_stretch = 0.2
@export var turn_speed = 20
@export var squash_and_stretch_speed = 50
@export var shield_follow_speed = 20
@export var damage_ring_follow_speed = 15
@export var damage_ring_spin_speed = 100

@onready var sprite := $Sprite
@onready var dash_timer := $DashTimer
@onready var dash_cooldown_timer := $DashCooldownTimer
@onready var move_particles := $MoveParticles
@onready var hitbox := $Hitbox
@onready var hitbox_collider := $Hitbox/CollisionShape
@onready var shield_anchor := $ShieldAnchor
@onready var shield := $ShieldAnchor/Shield
@onready var damage_ring := $DamageRing

var target_rotation = 0.0
var target_scale = Vector2.ONE
var next_time_to_fire = 0.0
var health: float
var bullet_scene = preload("res://player_bullet.tscn")
var wind_force = Vector2.ZERO
var can_move = true
var whirlpool_force = 0
var explosion_scene = preload("res://particles/explosion.tscn")

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	dash_timer.wait_time = Stats.dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	hitbox.set_collision_mask_value(4, true)
	Events.go_in_portal.connect(_on_go_into_portal)
	scale = Stats.player_size * Vector2.ONE
	health = Stats.max_health
	shield.scale = Stats.shield_size * Vector2.ONE

func _process(delta: float) -> void:
	if not can_move: return

	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, turn_speed * delta)
	sprite.scale = sprite.scale.move_toward(target_scale, squash_and_stretch_speed * delta)
	shield_anchor.position = shield_anchor.position.lerp(position, shield_follow_speed * delta)
	shield_anchor.rotation = get_angle_to(get_global_mouse_position()) - PI / 2
	damage_ring.position = damage_ring.position.lerp(position, damage_ring_follow_speed * delta)
	damage_ring.rotation_degrees += damage_ring_spin_speed * delta

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
	next_time_to_fire = Globals.time + 1.0 / Stats.fire_rate
	Globals.mouse.impact_rotation()
	AudioManager.play_sound(AudioManager.shoot)

	var bullet = bullet_scene.instantiate() as PlayerBullet
	var mouse_pos = get_global_mouse_position()
	bullet.global_position = global_position + ((mouse_pos - global_position).normalized() * 12)
	bullet.look_at(mouse_pos)
	bullet.rotation_degrees += randf_range(-Stats.bullet_spread, Stats.bullet_spread)
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
	Globals.camera.impact()
	Globals.camera.shake(0.1, 1)
	if health <= 0: die()
	else: Globals.hitstop(0.15)

func die():
	AudioManager.play_sound(AudioManager.explosion)
	Events.player_die.emit()
	Engine.time_scale = 0.2
	visible = false
	can_move = false
	hitbox_collider.set_deferred("disabled", true)
	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	Globals.world.add_child(explosion)
	await Globals.wait(1.5)
	SceneManager.change_scene(SceneManager.game_over_scene)
	Engine.time_scale = 1

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
	if health < Stats.max_health:
		health += Stats.regen
		update_health_ui()
