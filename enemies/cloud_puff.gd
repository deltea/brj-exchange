extends Area2D
class_name CloudPuff

@export var animation_speed = 2
@export var max_health = 50
@export var follow_speed = 30
@export var bullet_speed = 80

@onready var sprite := $Sprite

var health: float
var following_player = true
var bullet_scene = preload("res://enemy-bullets/cloud_bullet.tscn")
var explosion_scene = preload("res://particles/wall_hit.tscn")

func _enter_tree() -> void:
	health = max_health

func _process(delta: float) -> void:
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, animation_speed * delta)

	if following_player:
		position = position.move_toward(Globals.player.position, follow_speed * delta)

func take_damage():
	flash()

	health -= Stats.bullet_damage
	if health < 0: die()

func die():
	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	Globals.world.add_child(explosion)
	queue_free()

func flash():
	sprite.scale = Vector2.ONE * 1.2
	sprite.material.set_shader_parameter("enabled", true)
	await Globals.wait(0.1)
	sprite.material.set_shader_parameter("enabled", false)

func shoot():
	var bullet = bullet_scene.instantiate() as EnemyBullet
	bullet.position = position
	bullet.rotation = get_angle_to(Globals.player.position)
	bullet.speed = bullet_speed
	Globals.world.add_child(bullet)

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		(area as PlayerBullet).queue_free()
		take_damage()

func _on_attack_timer_timeout() -> void:
	following_player = false
	await Globals.wait(1.0)
	shoot()
	await Globals.wait(1.0)
	following_player = true
