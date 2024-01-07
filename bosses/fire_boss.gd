extends Boss

@onready var eye := $Eye

func _process(delta: float) -> void:
	var direction = (Globals.player.position - global_position).normalized()
	eye.position = direction * 5
