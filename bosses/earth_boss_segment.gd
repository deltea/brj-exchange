extends Sprite2D
class_name EarthBossSegment

@export var boss: EarthBoss = null
@export var follow_speed = 10
@export var gap = 15

var index: int
var next_segment: EarthBossSegment
var normal = Vector2.ZERO

func _ready() -> void:
	index = get_index()
	next_segment = get_parent().get_child(index + 1)

func _process(delta: float) -> void:
	var prev_position = position
	if boss:
		position = position.lerp(boss.position - (boss.normal * gap), follow_speed * delta)
	else:
		position = position.lerp(next_segment.position - (next_segment.normal * gap), follow_speed * delta)

	normal = (position - prev_position).normalized()
