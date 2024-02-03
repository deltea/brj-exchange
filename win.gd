extends CanvasLayer

@export var score_count_duration = 1.0

@onready var times_column := $Times
@onready var fire_time := $Times/FireTime
@onready var water_time := $Times/WaterTime
@onready var earth_time := $Times/EarthTime
@onready var air_time := $Times/AirTime

@onready var boss_total_time := $BossTime
@onready var health_penalty := $HealthPenalty
@onready var total_time_label := $TotalTime
@onready var dotted_line := $DottedLine

func _ready() -> void:
	if len(Scoring.boss_times) < 4: return

	times_column.visible = false
	boss_total_time.visible = false
	health_penalty.visible = false
	total_time_label.visible = false
	dotted_line.region_rect = Rect2(0, 0, 0, 4)

	await Globals.wait(1.0)

	var tween = get_tree().create_tween()

	tween.tween_callback(func(): times_column.visible = true)
	tween.tween_method(func(value): set_boss_time(value, fire_time), 0, snapped(Scoring.boss_times[0], 0.01), score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, water_time), 0, snapped(Scoring.boss_times[1], 0.01), score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, earth_time), 0, snapped(Scoring.boss_times[2], 0.01), score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, air_time), 0, snapped(Scoring.boss_times[3], 0.01), score_count_duration)

	var total_boss_time = 0
	for i in range(4):
		total_boss_time += Scoring.boss_times[i]
	var total_time = total_boss_time + Scoring.total_health_lost

	tween.tween_callback(func(): boss_total_time.visible = true)
	tween.tween_method(set_boss_total_time, 0, total_boss_time, score_count_duration)
	tween.tween_callback(func(): health_penalty.visible = true)
	tween.tween_method(set_health_penalty, 0, Scoring.total_health_lost, score_count_duration)
	tween.tween_property(dotted_line, "region_rect", Rect2(0, 0, 150, 4), score_count_duration)
	tween.tween_callback(func(): total_time_label.visible = true)
	tween.tween_method(set_total_time, 0, total_time, score_count_duration)

func set_boss_time(value: float, label: Label):
	label.text = str(value) + "s"

func set_boss_total_time(value: float):
	boss_total_time.text = "Boss Total Time: +%ss" % str(value)

func set_health_penalty(value: float):
	health_penalty.text = "Health Penalty: +%ss" % str(value)

func set_total_time(value: float):
	total_time_label.text = "Total Time: %ss" % str(value)

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene(SceneManager.main_menu_scene)
