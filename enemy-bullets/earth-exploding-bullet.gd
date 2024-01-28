extends EarthBouncyBullet

@export var acceleration = 100
@export var bullet_scene: PackedScene
@export var bullet_num = 3
@export var explosion_bullet_speed = 100
@export var explosion_range = 45.0

func _process(delta: float) -> void:
	speed += acceleration * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		for i in range(bullet_num):
			var bullet = bullet_scene.instantiate() as EnemyBullet
			var angle = rotation_degrees - (bullet_num - 1 * explosion_range / 2.0)
			bullet.position = position + (Vector2.from_angle(deg_to_rad(-angle)) * 10)
			bullet.rotation_degrees = -angle + (i * explosion_range / bullet_num)
			bullet.speed = explosion_bullet_speed
			Globals.world.call_deferred("add_child", bullet)

		destroy()
