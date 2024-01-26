extends Area2D
class_name Fish

@export var animation_speed = 5
@export var max_health = 10
@export var mouth_angle_max = 30

@onready var mouth_top := $MouthTop
@onready var mouth_bottom := $MouthBottom
@onready var tail := $Tail

var health: float
var explosion_scene = preload("res://particles/wall_hit.tscn")

func _enter_tree() -> void:
	health = max_health

func _process(delta: float) -> void:
	mouth_top.scale = mouth_top.scale.move_toward(Vector2.ONE, animation_speed * delta)
	mouth_bottom.scale = mouth_bottom.scale.move_toward(Vector2.ONE, animation_speed * delta)

	mouth_bottom.rotation_degrees = sin(Globals.time * 20.0 + PI) * mouth_angle_max + mouth_angle_max
	mouth_top.rotation_degrees = sin(Globals.time * 20.0) * mouth_angle_max - mouth_angle_max

func take_damage():
	flash()

	health -= Globals.player.bullet_damage
	if health < 0: die()

func die():
	var explosion = explosion_scene.instantiate() as GPUParticles2D
	explosion.position = position
	explosion.emitting = true
	Globals.add_child(explosion)
	queue_free()

func flash():
	mouth_top.scale = Vector2.ONE * 1.5
	mouth_bottom.scale = Vector2.ONE * 1.5

	mouth_top.material.set_shader_parameter("enabled", true)
	mouth_bottom.material.set_shader_parameter("enabled", true)
	tail.material.set_shader_parameter("enabled", true)

	await Globals.wait(0.1)

	mouth_top.material.set_shader_parameter("enabled", false)
	mouth_bottom.material.set_shader_parameter("enabled", false)
	tail.material.set_shader_parameter("enabled", false)

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		(area as PlayerBullet).queue_free()
		take_damage()
