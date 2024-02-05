extends TextureButton
class_name Card

@export var hover_y = -5
@export var animation_speed = 100
@export var disabled_color: Color = Color.DIM_GRAY

@onready var border := $Border
@onready var drop_shadow := $DropShadowUI
@onready var cost := $Cost
@onready var new_label := $NewLabel

var upgrade: UpgradeResource
var target_y = 0
var is_new = false
var is_disabled = false

func _ready() -> void:
	texture_normal = upgrade.texture
	cost.texture = load("res://assets/ui/cost-%s.png" % upgrade.cost)
	border.visible = false
	new_label.visible = is_new

	if is_disabled:
		disabled = true
		self_modulate = disabled_color
		cost.self_modulate = disabled_color

func _process(delta: float) -> void:
	drop_shadow.shadow_offset.y = move_toward(drop_shadow.shadow_offset.y, 8 - target_y, animation_speed * delta)
	position.y = move_toward(position.y, target_y, animation_speed * delta)

func _on_toggled(value: bool) -> void:
	border.visible = value
	if value:
		Events.card_select.emit(upgrade)
	else:
		Events.card_deselect.emit(upgrade)

func _on_mouse_entered() -> void:
	AudioManager.play_sound(AudioManager.card_hover)
	target_y = -10
	Events.card_hover.emit(true, upgrade, is_disabled)

func _on_mouse_exited() -> void:
	target_y = 0
	Events.card_hover.emit(false, upgrade, is_disabled)
