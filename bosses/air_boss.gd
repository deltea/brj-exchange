extends Area2D
class_name AirBoss

enum STATE {
	BULLET_WIND,
	BULLET_CURVE,
	TILES,
	CLOUD_PUFFS,
}

@onready var hands := $Hands

var state: STATE

func _ready() -> void:
	pass
