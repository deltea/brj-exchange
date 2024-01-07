extends Node

var player: Player
var mouse: Mouse
var world: World

var time = 0.0

func _process(delta: float) -> void:
	time += delta
