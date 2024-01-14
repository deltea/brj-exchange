extends Boss
class_name EarthBoss

@export var move_speed = 50

var normal = Vector2.ZERO

func _process(delta: float) -> void:
	var prev_position = position
	position = position.move_toward(Globals.player.position, move_speed * delta)
	normal = (position - prev_position).normalized()
	rotation = normal.angle() + PI / 2
