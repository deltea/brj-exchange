extends Boss

enum STATE {

}

@onready var eye := $Eye

func _process(_delta: float) -> void:
	var direction = (Globals.player.position - global_position).normalized()
	eye.position = direction * 5

func _physics_process(delta: float) -> void:
	position = position.move_toward(Globals.player.position, 30 * delta)
