extends Boss
class_name AirBoss

enum STATE {
	BULLET_WIND,
	BULLET_CURVE,
	TILES,
	CLOUD_PUFFS,
}

@onready var hands := $Hands

var state: STATE
var state_index = 0

func _ready() -> void:
	# next_state()
	pass

func bullet_wind_state():
	next_state()

func bullet_curve_state():
	next_state()

func tiles_state():
	next_state()

func cloud_puffs_state():
	next_state()

func next_state():
	match state_index:
		STATE.BULLET_WIND: bullet_wind_state()
		STATE.BULLET_CURVE: bullet_curve_state()
		STATE.TILES: tiles_state()
		STATE.CLOUD_PUFFS: cloud_puffs_state()

	state_index = (state_index + 1) % len(STATE.keys())
