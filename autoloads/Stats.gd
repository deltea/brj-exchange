extends Node

@export var default_stats: StatsResource

var current: StatsResource

func _ready() -> void:
	reset_stats()

func reset_stats():
	current = default_stats.duplicate()
