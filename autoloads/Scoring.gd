extends Node

var boss_times: Array[float] = []
var boss_timer = 0.0
var total_health_lost = 0.0

func _process(delta: float) -> void:
	boss_timer += delta
	if Globals.canvas != null: Globals.canvas.set_time(boss_timer)

func add_time():
	boss_times.push_back(boss_timer)
	print("time: ", boss_timer)
	boss_timer = 0.0
