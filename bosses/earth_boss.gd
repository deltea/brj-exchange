extends Boss
class_name EarthBoss

enum STATE {
	BULLET_EXPLOSION,
	ROCKS,
}

@export var animation_speed = 2
@export var movement_speed = 200
@export var rotation_speed = 200
@export var bullet_explosion_num = 5
@export var bullet_explosion_speed = 150

@onready var sprite := $Sprite

var state_index = -1
var velocity = Vector2.ZERO
var bouncy_bullet_scene = preload("res://enemy-bullets/earth_bouncy_bullet.tscn")

func _ready() -> void:
	velocity = Vector2.from_angle(randf_range(0, PI * 2)) * movement_speed
	next_state()

func _process(delta: float) -> void:
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, animation_speed * delta)

func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	position += velocity * delta

func bullet_explosion_state():
	await Globals.wait(1.0)

	var prev_velocity = velocity
	velocity = Vector2.ZERO
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
	next_state()

func next_state(index = null):
	state_index = (state_index + 1) % len(STATE.keys())

	match index if index else state_index:
		STATE.BULLET_EXPLOSION: bullet_explosion_state()
		STATE.ROCKS: rocks_state()

func flash():
	sprite.scale = Vector2.ONE * 1.2
	sprite.material.set_shader_parameter("enabled", true)
	await Globals.wait(0.2)
	sprite.material.set_shader_parameter("enabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		var wall = body as Wall
		velocity = velocity.bounce(Vector2.from_angle(wall.rotation + PI / 2))
