extends TextureProgressBar

@export var esc_hold_duration = 0.5

var esced = false

func _ready() -> void:
	max_value = esc_hold_duration

func _process(delta: float) -> void:
	if Input.is_action_just_released("esc"):
		esced = false

	if Input.is_action_pressed("esc") and not esced:
		update_esc_hold(delta)
	else:
		update_esc_hold(-delta)

func update_esc_hold(amount: float):
	value += amount
	visible = value > 0
	if value == esc_hold_duration:
		esced = true
		value = 0
		visible = false
		SceneManager.change_scene(SceneManager.main_menu_scene)
