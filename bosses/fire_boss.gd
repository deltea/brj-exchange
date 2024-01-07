extends Boss

enum STATE {
	FIREBALLS,
	BULLET_RING,
	LASER_EXTRUDE,
	LASER_FOLLOW,
}

@onready var eye := $Eye

var state = STATE.FIREBALLS

func _process(_delta: float) -> void:
	var direction = (Globals.player.position - global_position).normalized()
	eye.position = direction * 5
	choose_random_state()

func fireballs_state():
	choose_random_state()

func bullet_ring_state():
	choose_random_state()

func laser_extrude_state():
	choose_random_state()

func laser_follow_state():
	choose_random_state()

func choose_random_state():
	state = STATE.keys()[randi() % STATE.size()]
