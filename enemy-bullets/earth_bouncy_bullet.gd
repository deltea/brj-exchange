extends EnemyBullet
class_name EarthBouncyBullet

var health = 2

func _on_body_entered(body: Node2D) -> void:
	if not body is Wall: return
	var wall = body as Wall
	print("wall!")

	health -= 1
	if health <= 0:
		destroy()
	else:
		var wall_normal = Vector2.from_angle(wall.rotation + PI / 2)
		rotation = Vector2.from_angle(rotation).bounce(wall_normal).angle()

