extends Bullet
class_name PlayerBullet

var bounces = 0
var velocity = Vector2.ZERO

func _ready() -> void:
	bounces = Stats.bullet_bounce

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		bounces -= 1
		if bounces < 0:
			destroy()
		else:
			var wall = body as Wall
			var wall_normal = Vector2.from_angle(wall.rotation + PI / 2)
			rotation = Vector2.from_angle(rotation).bounce(wall_normal).angle()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	if Stats.bullet_bounce == 0: queue_free()
