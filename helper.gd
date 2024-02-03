extends Sprite2D
class_name Helper

@export var hands_offset = Vector2(0, 7)
@export var hands_smoothing = 20.0
@export var follow_speed = 5.0
@export var bullet_speed = 400.0
@export var animation_speed = 2.0
@export var bullet_num = 3
@export var fire_delay = 0.1

@onready var hands := $Hands

var player_offset: Vector2
var bullet_scene = preload("res://helper_bullet.tscn")

func _process(delta: float) -> void:
	hands.position = hands.position.lerp(position + hands_offset, hands_smoothing * delta)
	position = position.lerp(Globals.player.position + player_offset, follow_speed * delta)
	scale = scale.move_toward(Vector2.ONE, animation_speed * delta)

func _on_fire_timer_timeout() -> void:
	for i in bullet_num:
		scale = Vector2.ONE * 1.5
		var bullet = bullet_scene.instantiate() as PlayerBullet
		var mouse_pos = get_global_mouse_position()
		bullet.position = position
		bullet.look_at(mouse_pos)
		bullet.speed = bullet_speed
		Globals.world.add_child(bullet)

		await Globals.wait(fire_delay)
