extends Boss
class_name WaterBoss

enum STATE {
	CANNON,
	BULLET_SPIRAL,
	FISHIES,
	WHIRLPOOL,
}

@export var animation_speed = 2
@export var whirlpool: Whirlpool
@export var whirlpool_force = 60
@export var whirlpool_fish_num = 50
@export var whirlpool_fish_delay = 0.1
@export var whirlpool_fish_speed = 0
@export var whirlpool_fish_acceleration = 3
@export var whirlpool_fish_radius = 220
@export var cannon_delay = 1
@export var cannon_bullet_num = 10
@export var cannon_bullet_speed = 150
@export var bullet_spiral_move_speed = 200
@export var bullet_spiral_num = 100
@export var bullet_spiral_delay = 0.1
@export var bullet_spiral_speed = 100
@export var fishies_delay = 0.5
@export var fishies_num = 50
@export var fishies_speed = 200
@export var fishies_min = Vector2(-240, -240)
@export var fishies_max = Vector2(240, 240)

@onready var sprite := $Sprite
@onready var mouth_top := $MouthTop
@onready var mouth_bottom := $MouthBottom
@onready var eye := $MouthTop/Eye

var state_index = -1
var fish_scene = preload("res://enemies/fish.tscn")
var bullet_scene = preload("res://enemy-bullets/water_bullet.tscn")
var big_bullet_scene = preload("res://enemy-bullets/water_big_bullet.tscn")

func _ready() -> void:
	await Globals.wait(start_delay)
	next_state()

func _process(delta: float) -> void:
	mouth_top.scale = mouth_top.scale.move_toward(Vector2.ONE, animation_speed * delta)
	mouth_bottom.scale = mouth_bottom.scale.move_toward(Vector2.ONE, animation_speed * delta)

	mouth_bottom.rotation_degrees = sin(Globals.time * 10.0 + PI) * 30 + 30
	mouth_top.rotation_degrees = sin(Globals.time * 10.0) * 30 - 30

func _physics_process(delta: float) -> void:
	if state_index == STATE.BULLET_SPIRAL:
		look_at(Vector2.ZERO)
		position += Vector2.from_angle(rotation + PI / 2) * bullet_spiral_move_speed * delta

# Attack methods
func cannon_state():
	for i in cannon_bullet_num:
		var random_pos = random_radius(160)
		move(random_pos, cannon_delay)
		await look(random_pos.angle() + PI, cannon_delay)

		var bullet = big_bullet_scene.instantiate() as WaterBigBullet
		bullet.position = random_pos
		bullet.rotation = rotation
		bullet.speed = cannon_bullet_speed
		Globals.world.add_child(bullet)

	next_state()

func bullet_spiral_state():
	var random_pos = random_radius(160)
	move(random_pos, cannon_delay)
	await look(random_pos.angle() + PI, cannon_delay)

	for i in bullet_spiral_num:
		var bullet = bullet_scene.instantiate() as EnemyBullet
		bullet.position = position
		bullet.rotation = rotation
		bullet.speed = bullet_spiral_speed
		Globals.world.add_child(bullet)

		await Globals.wait(bullet_spiral_delay)

	next_state()

func fishies_state():
	move(Vector2.ZERO, 1.0)
	await look(0, 1.0)

	for i in fishies_num:
		var is_horizontal = randf() > 0.5
		var random_pos = Vector2.ZERO
		if is_horizontal:
			random_pos.x = fishies_min.x if randf() > 0.5 else fishies_max.x
			random_pos.y = randf_range(fishies_min.y, fishies_max.y)
		else:
			random_pos.y = fishies_min.y if randf() > 0.5 else fishies_max.y
			random_pos.x = randf_range(fishies_min.x, fishies_max.x)

		var direction = random_pos.normalized() * (Vector2.LEFT if is_horizontal else Vector2.UP)

		var fish = fish_scene.instantiate()
		fish.position = random_pos
		fish.rotation = direction.angle()
		fish.speed = fishies_speed
		Globals.world.add_child(fish)

		await Globals.wait(fishies_delay)

	next_state()

func whirlpool_state():
	move(Vector2(0, -100), 2.0)
	await look(PI / 2, 2.0)
	Globals.player.whirlpool_force = whirlpool_force
	whirlpool.target_scale = Vector2.ONE
	whirlpool.toggle_collider(true)

	for i in whirlpool_fish_num:
		var fish = fish_scene.instantiate() as Fish
		var random_rotation = randf_range(0, PI * 2)
		var random_position = Vector2.from_angle(random_rotation) * whirlpool_fish_radius
		fish.position = random_position
		fish.rotation = random_rotation + PI
		fish.acceleration = whirlpool_fish_acceleration
		fish.speed = whirlpool_fish_speed
		Globals.world.add_child(fish)

		await Globals.wait(whirlpool_fish_delay)

	Globals.player.whirlpool_force = 0
	whirlpool.target_scale = Vector2.ZERO
	whirlpool.toggle_collider(true)

	next_state()

func move_and_look(target_position: Vector2, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation", rotation + get_angle_to(target_position), duration / 2)
	tween.tween_property(self, "position", target_position, duration / 2)
	return tween.finished

func move(target_position: Vector2, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", target_position, duration)
	return tween.finished

func look(angle: float, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation", angle, duration)
	return tween.finished

func random_radius(radius: float):
	return Vector2.from_angle(randf_range(0, PI * 2)) * radius

func next_state(index = null):
	state_index = (state_index + 1) % len(STATE.keys())

	match index if index else state_index:
		STATE.CANNON: cannon_state()
		STATE.BULLET_SPIRAL: bullet_spiral_state()
		STATE.FISHIES: fishies_state()
		STATE.WHIRLPOOL: whirlpool_state()

func flash():
	mouth_top.scale = Vector2.ONE * 1.2
	mouth_bottom.scale = Vector2.ONE * 1.2

	sprite.material.set_shader_parameter("enabled", true)
	eye.material.set_shader_parameter("enabled", true)
	mouth_top.material.set_shader_parameter("enabled", true)
	mouth_bottom.material.set_shader_parameter("enabled", true)

	await Globals.wait(0.2)

	sprite.material.set_shader_parameter("enabled", false)
	eye.material.set_shader_parameter("enabled", false)
	mouth_top.material.set_shader_parameter("enabled", false)
	mouth_bottom.material.set_shader_parameter("enabled", false)
