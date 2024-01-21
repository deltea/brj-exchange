extends Boss
class_name AirBoss

enum STATE {
	BULLET_CURVE,
	BULLET_WIND,
	TILES,
	CLOUD_PUFFS,
}

@export var wind_particles: CPUParticles2D
@export var wind_force = Vector2(80, 0)
@export var wind_bullet_num = 100
@export var wind_bullet_speed = 250
@export var bullet_curve_num = 10
@export var bullet_curve_speed = 150

@onready var hands := $Hands

var state_index = 0
var bullet_scene = preload("res://enemy-bullets/air_bullet.tscn")
var curvy_bullet_scene = preload("res://enemy-bullets/curvy_bullet.tscn")

func _ready() -> void:
	next_state(0)

func bullet_curve_state():
	for i in range(bullet_curve_num):
		await Globals.wait(0.5)

		var bullet = curvy_bullet_scene.instantiate() as CurvyBullet
		bullet.position = Vector2(448, 0)
		bullet.rotation = bullet.get_angle_to(Globals.player.position)
		bullet.speed = bullet_curve_speed
		Globals.world.add_child(bullet)

	next_state(1)

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

	next_state(0)

func tiles_state():
	next_state()

func cloud_puffs_state():
	next_state()

func next_state(index: int = state_index):
	match index:
		STATE.BULLET_CURVE: bullet_curve_state()
		STATE.BULLET_WIND: bullet_wind_state()
		STATE.TILES: tiles_state()
		STATE.CLOUD_PUFFS: cloud_puffs_state()

	state_index = (state_index + 1) % len(STATE.keys())
