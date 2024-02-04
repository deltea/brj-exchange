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
@onready var cards_row := $Cards
@onready var cards_owned_text := $CardsOwnedText

var card_scene = preload("res://ui/card.tscn")

func _ready() -> void:
	AudioManager.play_sound(AudioManager.win)
	if len(Scoring.boss_times) < 4: return

	times_column.visible = false
	boss_total_time.visible = false
	health_penalty.visible = false
	total_time_label.visible = false
	dotted_line.region_rect = Rect2(0, 0, 0, 4)
	cards_row.visible = false
	cards_owned_text.visible = false

	await Globals.wait(1.0)

	var tween = get_tree().create_tween()

	tween.tween_callback(func(): times_column.visible = true)
	tween.tween_method(func(value): set_boss_time(value, fire_time), 0.0, Scoring.boss_times[0], score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, water_time), 0.0, Scoring.boss_times[1], score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, earth_time), 0.0, Scoring.boss_times[2], score_count_duration)
	tween.tween_method(func(value): set_boss_time(value, air_time), 0.0, Scoring.boss_times[3], score_count_duration)

	var total_boss_time = 0
	for i in range(4):
		total_boss_time += Scoring.boss_times[i]
	var total_time = total_boss_time + Scoring.total_health_lost

	tween.tween_callback(func(): boss_total_time.visible = true)
	tween.tween_method(set_boss_total_time, 0.0, total_boss_time, score_count_duration)
	tween.tween_callback(func(): health_penalty.visible = true)
	tween.tween_method(set_health_penalty, 0.0, Scoring.total_health_lost, score_count_duration)
	tween.tween_property(dotted_line, "region_rect", Rect2(0, 0, 150, 4), score_count_duration)
	tween.tween_callback(func(): total_time_label.visible = true)
	tween.tween_method(set_total_time, 0.0, total_time, score_count_duration)

	for upgrade in UpgradeManager.current_upgrades:
		var card = card_scene.instantiate() as Card
		card.upgrade = upgrade
		cards_row.add_child(card)
	tween.tween_callback(func(): cards_row.visible = true)
	tween.tween_callback(func(): cards_owned_text.visible = true)

func set_boss_time(value: float, label: Label):
	AudioManager.play_sound(AudioManager.score)
	label.text = str(snapped(value, 0.01)) + "s"

func set_boss_total_time(value: float):
	AudioManager.play_sound(AudioManager.score)
	boss_total_time.text = "Boss Total Time: +%ss" % str(snapped(value, 0.01))

func set_health_penalty(value: float):
	AudioManager.play_sound(AudioManager.score)
	health_penalty.text = "Health Penalty: +%ss" % str(snapped(value, 0.01))

func set_total_time(value: float):
	AudioManager.play_sound(AudioManager.score)
	total_time_label.text = "Total Time: %ss" % str(snapped(value, 0.01))

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene(SceneManager.main_menu_scene)
