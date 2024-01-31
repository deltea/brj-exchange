extends Boss
class_name EarthBoss

enum STATE {
	BULLET_EXPLOSION,
	ROCKS,
	EARTHQUAKE,
}

@export var animation_speed = 2
@export var movement_speed = 200
@export var rotation_speed = 200
@export var bullet_explosion_num = 5
@export var bullet_explosion_speed = 150
@export var earthquake_bullet_num = 10
@export var earthquake_bullet_delay = 1.0
@export var earthquake_path: Path2D

@onready var sprite := $Sprite

var state_index = -1
var velocity = Vector2.ZERO
var bouncy_bullet_scene = preload("res://enemy-bullets/earth_bouncy_bullet.tscn")
var rock_scene = preload("res://enemies/rock_big.tscn")
var exploding_bullet_scene = preload("res://enemy-bullets/earth_exploding_bullet.tscn")

func _ready() -> void:
	await Globals.wait(start_delay)
	next_state()
	velocity = Vector2.from_angle(randf_range(0, PI * 2)) * movement_speed

func _process(delta: float) -> void:
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, animation_speed * delta)

func _physics_process(delta: float) -> void:
	if not state_index == STATE.EARTHQUAKE:
		rotation_degrees += rotation_speed * delta
		position += velocity * delta

func bullet_explosion_state():
	for x in range(5):
		await Globals.wait(1.0)

		var prev_velocity = velocity
		velocity = Vector2(0.5, 0.5)
		await Globals.wait(0.5)

		for i in bullet_explosion_num:
			var bullet = bouncy_bullet_scene.instantiate() as EnemyBullet
			bullet.position = position
			bullet.rotation = PI * 2 / bullet_explosion_num * i
			bullet.speed = bullet_explosion_speed
			Globals.world.add_child(bullet)

		await Globals.wait(0.5)
		velocity = prev_velocity

	next_state()

func rocks_state():
	await Globals.wait(1.0)

	var prev_velocity = velocity
	velocity = Vector2(0.5, 0.5)
	await Globals.wait(0.5)

	var rock = rock_scene.instantiate() as Rock
	rock.position = position
	Globals.world.add_child(rock)

	await Globals.wait(0.5)
	velocity = prev_velocity

	next_state()

func earthquake_state():
	await move(Vector2.ZERO, 0, 2.0)

	Globals.camera.shake(earthquake_bullet_num * earthquake_bullet_delay, 1)

	for i in range(earthquake_bullet_num):
		var bullet = exploding_bullet_scene.instantiate() as EnemyBullet
		var path_length = earthquake_path.curve.get_baked_length()
		bullet.position = earthquake_path.curve.sample_baked(randf_range(0, path_length))
		bullet.rotation = PI / 2
		bullet.speed = 0
		Globals.world.add_child(bullet)

		await Globals.wait(earthquake_bullet_delay)

	next_state()

func next_state(index = null):
	state_index = (state_index + 1) % len(STATE.keys())

	match index if index else state_index:
		STATE.BULLET_EXPLOSION: bullet_explosion_state()
		STATE.ROCKS: rocks_state()
		STATE.EARTHQUAKE: earthquake_state()

func move(target_position: Vector2, target_rotation: float, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(self, "position", target_position, duration)
	tween.tween_property(self, "rotation", target_rotation, duration)
	return tween.finished

func flash():
	sprite.scale = Vector2.ONE * 1.2
	sprite.material.set_shader_parameter("enabled", true)
	await Globals.wait(0.2)
	sprite.material.set_shader_parameter("enabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		var wall = body as Wall
		velocity = velocity.bounce(Vector2.from_angle(wall.rotation + PI / 2))
