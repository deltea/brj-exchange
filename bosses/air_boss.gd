extends Boss
class_name AirBoss

enum STATE {
	BULLET_CURVE,
	BULLET_WIND,
	CLOUD_PUFFS,
	TILES,
}

@export var wind_particles: CPUParticles2D
@export var wind_force = Vector2(60, 0)
@export var wind_bullet_num = 50
@export var wind_bullet_speed = 250
@export var bullet_curve_num = 10
@export var bullet_curve_speed = 150
@export var cloud_puffs_delay = 1
@export var tiles_num = 40
@export var tiles_delay = 0.1
@export var tiles_position_min = Vector2.ZERO
@export var tiles_position_max = Vector2.ZERO

@onready var hands := $Hands

var state_index = 0
var bullet_scene = preload("res://enemy-bullets/air_bullet.tscn")
var curvy_bullet_scene = preload("res://enemy-bullets/curvy_bullet.tscn")
var cloud_puff_scene = preload("res://enemies/cloud_puff.tscn")
var tile_scene = preload("res://enemies/enemy_tile.tscn")

func _ready() -> void:
	next_state()

func bullet_curve_state():
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
	for i in range(1):
		await Globals.wait(cloud_puffs_delay)
		var cloud_puff = cloud_puff_scene.instantiate()
		cloud_puff.position = position
		Globals.world.add_child(cloud_puff)

	next_state()

func tiles_state():
	for i in range(tiles_num):
		await Globals.wait(tiles_delay)

		var tile = tile_scene.instantiate()
		var random_x = randf_range(tiles_position_min.x, tiles_position_max.x)
		var random_y = randf_range(tiles_position_min.y, tiles_position_max.y)
		tile.position = Vector2(random_x, random_y)
		Globals.world.add_child(tile)

	next_state()

func next_state(index: int = state_index):
	match index:
		STATE.BULLET_CURVE: bullet_curve_state()
		STATE.BULLET_WIND: bullet_wind_state()
		STATE.CLOUD_PUFFS: cloud_puffs_state()
		STATE.TILES: tiles_state()

	state_index = (state_index + 1) % len(STATE.keys())
