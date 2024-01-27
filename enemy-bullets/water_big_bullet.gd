extends EnemyBullet
class_name WaterBigBullet

var angle = 0

func _process(delta: float) -> void:
	angle += 0.3
	position += Vector2.from_angle(angle) * 3
