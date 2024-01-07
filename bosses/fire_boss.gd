extends Boss

enum STATE {
	FIREBALLS,
	BULLET_RING,
	LASER_EXTRUDE,
	LASER_FOLLOW,
}

@export var animation_speed = 2
@export var fireball_positions: Array[Marker2D]
@export var fireball_speed = 90
@export var bullet_ring_num = 20
@export var bullet_ring_speed = 100

@onready var eye := $Eye

var state = STATE.FIREBALLS
var fireball_scene = preload("res://enemy-bullets/fireball.tscn")
var bullet_scene = preload("res://enemy-bullets/fire_bullet.tscn")

func _ready() -> void:
	choose_random_state()

func _process(delta: float) -> void:
	var direction = (Globals.player.position - global_position).normalized()
	eye.position = direction * 5

	scale = scale.move_toward(Vector2.ONE, animation_speed * delta)

func fireballs_state():
	for i in range(2):
		var random_position = fireball_positions.pick_random().position
		await move(random_position, 1.5)
		await Globals.wait(0.5)

		for x in range(3):
			fire_fireball()
			await Globals.wait(0.5)

	choose_random_state()

func bullet_ring_state():
	await move(Vector2(352, 192), 2.0)

	var offset = 0
	for i in range(2):
		for x in range(bullet_ring_num):
			scale = Vector2.ONE * 1.5

			var bullet = bullet_scene.instantiate() as EnemyBullet
			bullet.position = position
			bullet.rotation_degrees = 360.0 / bullet_ring_num * x + offset
			bullet.speed = bullet_ring_speed

			Globals.world.add_child(bullet)

		offset += 9
		await Globals.wait(0.4)

	choose_random_state()

func laser_extrude_state():
	choose_random_state()

func laser_follow_state():
	choose_random_state()

func fire_fireball():
	scale = Vector2.ONE * 1.5
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

func choose_random_state():
	state = STATE.keys()[randi() % STATE.size()]
	match state:
		"FIREBALLS": fireballs_state()
		"BULLET_RING": bullet_ring_state()
		"LASER_EXTRUDE": fireballs_state()
		"LASER_FOLLOW": bullet_ring_state()
