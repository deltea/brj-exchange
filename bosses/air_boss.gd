extends Boss
class_name AirBoss

enum STATE {
	BULLET_CURVE,
	BULLET_WIND,
	CLOUD_PUFFS,
	TILES,
}

@export var hand_speed = 100
@export var wind_particles: CPUParticles2D
@export var wind_force = Vector2(60, 0)
@export var wind_bullet_num = 30
@export var wind_bullet_speed = 250
@export var bullet_curve_num = 10
@export var bullet_curve_speed = 150
@export var cloud_puffs_num = 1
@export var cloud_puff_positions: Array[Marker2D]
@export var tiles_num = 40
@export var tiles_delay = 0.1
@export var tiles_position_min = Vector2.ZERO
@export var tiles_position_max = Vector2.ZERO

@onready var hands := $Hands

var state_index = -1
var bullet_scene = preload("res://enemy-bullets/air_bullet.tscn")
var curvy_bullet_scene = preload("res://enemy-bullets/curvy_bullet.tscn")
var cloud_puff_scene = preload("res://enemies/cloud_puff.tscn")
var tile_scene = preload("res://enemies/enemy_tile.tscn")
var hand_position = Vector2.ZERO

func _ready() -> void:
	next_state()

func _process(delta: float) -> void:
	match state_index:
		STATE.BULLET_CURVE: hand_position = Vector2(0, sin(3.0 * Globals.time) * 5.0)
		STATE.CLOUD_PUFFS: hand_position = Vector2.ZERO
		STATE.TILES: hand_position = Vector2.ZERO

	hands.position = hands.position.move_toward(hand_position, hand_speed * delta)

func bullet_curve_state():
	await move(Vector2(0, -104), 1.0)

	for i in range(bullet_curve_num):
		await Globals.wait(0.5)

		var bullet = curvy_bullet_scene.instantiate() as CurvyBullet
		bullet.position = Vector2(448, 0)
		bullet.rotation = bullet.get_angle_to(Globals.player.position)
		bullet.speed = bullet_curve_speed
		Globals.world.add_child(bullet)

	next_state()

func bullet_wind_state():
	wind_particles.emitting = true
	Globals.player.wind_force = wind_force

	wind_particles.position.x = -448
	wind_particles.rotation_degrees = 0

	for x in range(2):
		await move(wind_particles.position / 2, 1.5)
		hand_position = -wind_particles.position.normalized() * 6

		for i in range(wind_bullet_num):
			await Globals.wait(0.05)

			var bullet = bullet_scene.instantiate() as EnemyBullet
			bullet.position.x = wind_particles.position.x
			bullet.position.y = randf_range(-136, 136)
			bullet.rotation_degrees = wind_particles.rotation_degrees
			bullet.speed = wind_bullet_speed
			Globals.world.add_child(bullet)

		await Globals.wait(3.0)

		wind_particles.position.x = -wind_particles.position.x
		wind_particles.rotation_degrees = 180
		Globals.player.wind_force = -wind_force

	wind_particles.emitting = true
	Globals.player.wind_force = Vector2.ZERO

	next_state()

func cloud_puffs_state():
	for i in range(cloud_puffs_num):
		var random_position = cloud_puff_positions.pick_random().position
		await move(random_position, 2)

		var cloud_puff = cloud_puff_scene.instantiate()
		cloud_puff.position = position
		Globals.world.add_child(cloud_puff)

	next_state()

func tiles_state():
	await move(Vector2(0, 104), 1.5)

	for i in range(tiles_num):
		await Globals.wait(tiles_delay)

		var tile = tile_scene.instantiate()
		var random_x = randf_range(tiles_position_min.x, tiles_position_max.x)
		var random_y = randf_range(tiles_position_min.y, tiles_position_max.y)
		tile.position = Vector2(random_x, random_y)
		Globals.world.add_child(tile)

	next_state()

func move(target_position: Vector2, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position", target_position, duration)
	return tween.finished

func next_state(index = null):
	state_index = (state_index + 1) % len(STATE.keys())

	match index if index else state_index:
		STATE.BULLET_CURVE: bullet_curve_state()
		STATE.BULLET_WIND: bullet_wind_state()
		STATE.CLOUD_PUFFS: cloud_puffs_state()
		STATE.TILES: tiles_state()
