extends Boss
class_name WaterBoss

enum STATE {
	WHIRLPOOL,
	FISHIES,
}

@export var animation_speed = 2
@export var whirlpool: Whirlpool
@export var whirlpool_force = 60
@export var whirlpool_fish_num = 50
@export var whirlpool_fish_delay = 0.1
@export var whirlpool_fish_speed = 0
@export var whirlpool_fish_acceleration = 3
@export var whirlpool_fish_radius = 220

@onready var sprite := $Sprite
@onready var mouth_top := $MouthTop
@onready var mouth_bottom := $MouthBottom
@onready var eye := $MouthTop/Eye

var state_index = -1
var fish_scene = preload("res://enemies/fish.tscn")

func _ready() -> void:
	next_state()

func _process(delta: float) -> void:
	mouth_top.scale = mouth_top.scale.move_toward(Vector2.ONE, animation_speed * delta)
	mouth_bottom.scale = mouth_bottom.scale.move_toward(Vector2.ONE, animation_speed * delta)

	mouth_bottom.rotation_degrees = sin(Globals.time * 10.0 + PI) * 30 + 30
	mouth_top.rotation_degrees = sin(Globals.time * 10.0) * 30 - 30

# Attack methods
func whirlpool_state():
	await move(Vector2(randf_range(-180, 180), randf_range(-180, 180)), 2.0)
	Globals.player.whirlpool_force = whirlpool_force
	whirlpool.target_scale = Vector2.ONE

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

	whirlpool.target_scale = Vector2.ZERO

	Globals.player.whirlpool_force = 0

	next_state()

func fishies_state():
	next_state()

func move(target_position: Vector2, duration: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation", rotation + get_angle_to(target_position), duration / 2)
	tween.tween_property(self, "position", target_position, duration / 2)
	return tween.finished

func next_state(index = null):
	state_index = (state_index + 1) % len(STATE.keys())

	match index if index else state_index:
		STATE.WHIRLPOOL: whirlpool_state()
		STATE.FISHIES: fishies_state()

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
