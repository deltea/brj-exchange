extends Boss
class_name FireBoss

enum STATE {
	FIREBALLS,
	BULLET_RING,
	# LASER,
	BULLET_SPIRAL,
	BULLET_CORNERS,
}

@export var animation_speed = 2
@export var fireball_positions: Array[Marker2D]
@export var fireball_speed = 90
@export var bullet_ring_num = 20
@export var bullet_ring_speed = 100
@export var laser_telegraph = 0.6
@export var laser_speed = 0.8
@export var bullet_spiral_num = 60
@export var bullet_spiral_speed = 200
@export var bullet_corners_num = 5
@export var bullet_corners_spread = 10
@export var bullet_corners_speed = 150

@onready var sprite := $Sprite
@onready var eye := $Eye
@onready var laser_ray := $LaserRay
@onready var laser_line := $LaserLine
@onready var flames_particles := $FlamesParticles

var state: STATE
var state_index = 0
var fireball_scene = preload("res://enemy-bullets/fireball.tscn")
var bullet_scene = preload("res://enemy-bullets/fire_bullet.tscn")

func _ready() -> void:
	next_state()

func _process(delta: float) -> void:
	var direction = (Globals.player.position - global_position).normalized()
	eye.position = direction * 5

	sprite.scale = sprite.scale.move_toward(Vector2.ONE, animation_speed * delta)

	laser_line.set_point_position(0, global_position)
	# if not state == STATE.LASER: laser_line.set_point_position(1, global_position)
	laser_line.set_point_position(1, global_position)

func fireballs_state():
	for i in range(2):
		var random_position = fireball_positions.pick_random().position
		await move(random_position, 1.5)
		await Globals.wait(0.2)

		for x in range(3):
			fire_fireball()
			await Globals.wait(0.5)

	next_state()

func bullet_ring_state():
	await move(Vector2(352, 192), 2.0)

	var offset = 0
	for i in range(3):
		for x in range(bullet_ring_num):
			sprite.scale = Vector2.ONE * 1.5

			var bullet = bullet_scene.instantiate() as EnemyBullet
			bullet.position = position
			bullet.rotation_degrees = 360.0 / bullet_ring_num * x + offset
			bullet.speed = bullet_ring_speed

			Globals.world.add_child(bullet)

		offset += 9
		await Globals.wait(0.5)

	next_state()

func laser_state():
	for i in range(5):
		var direction = get_angle_to(Globals.player.position) - PI / 2
		laser_ray.rotation = direction

		var point = laser_ray.get_collision_point()
		if point:
			laser_line.set_point_position(1, point)
			laser_line.default_color = Color(255, 255, 255, 0.2)
			laser_line.width = 0

			var tween = get_tree().create_tween()
			tween.tween_property(laser_line, "width", 30, laser_telegraph)
			tween.tween_property(laser_line, "default_color", Color.WHITE, 0)
			tween.tween_property(laser_line, "width", 0, 0.1).set_delay(0.1)

		await Globals.wait(laser_speed)

	next_state()

func bullet_spiral_state():
	await move(Vector2(352, 192), 2.0)

	for i in range(bullet_spiral_num):
		sprite.scale = Vector2.ONE * 1.2

		var bullet = bullet_scene.instantiate() as EnemyBullet
		bullet.position = position
		bullet.rotation_degrees = 720.0 / bullet_spiral_num * i
		bullet.speed = bullet_spiral_speed

		Globals.world.add_child(bullet)

		await Globals.wait(0.05)

	await Globals.wait(0.4)

	next_state()

func bullet_corners_state():
	for i in range(4):
		var random_position = fireball_positions.pick_random().position
		await move(random_position, 1.0)
		sprite.scale = Vector2.ONE * 1.5

		var angle = rad_to_deg((get_angle_to(Globals.player.position))) - ((bullet_corners_num - 1) * bullet_corners_spread / 2.0)
		for x in range(bullet_corners_num):
			var bullet = bullet_scene.instantiate() as EnemyBullet
			bullet.position = position
			bullet.rotation_degrees = angle + x * bullet_corners_spread
			bullet.speed = bullet_corners_speed

			Globals.world.add_child(bullet)

	next_state()

func fire_fireball():
	sprite.scale = Vector2.ONE * 1.5
	var fireball = fireball_scene.instantiate() as Fireball
	var direction = (Globals.player.position - position).normalized()
	fireball.position = position
	fireball.rotation = direction.angle()
	fireball.speed = fireball_speed

	Globals.world.add_child(fireball)

func move(target_position: Vector2, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", target_position, duration)
	return tween.finished

func next_state():
	match state_index:
		STATE.FIREBALLS: fireballs_state()
		STATE.BULLET_RING: bullet_ring_state()
		# STATE.LASER: laser_state()
		STATE.BULLET_SPIRAL: bullet_spiral_state()
		STATE.BULLET_CORNERS: bullet_corners_state()

	state_index = (state_index + 1) % len(STATE.keys())

func flash():
	sprite.scale = Vector2.ONE * 1.2

	sprite.material.set_shader_parameter("enabled", true)
	eye.material.set_shader_parameter("enabled", true)
	flames_particles.material.set_shader_parameter("enabled", true)

	await Globals.wait(0.2)

	sprite.material.set_shader_parameter("enabled", false)
	eye.material.set_shader_parameter("enabled", false)
	flames_particles.material.set_shader_parameter("enabled", false)
