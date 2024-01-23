extends TextureButton
class_name Card

@export var hover_y = -5
@export var animation_speed = 100

@onready var border := $Border
@onready var drop_shadow := $DropShadowUI
@onready var cost := $Cost

var upgrade: UpgradeResource
var target_y = 0

func _ready() -> void:
	texture_normal = upgrade.texture
	cost.texture = load("res://assets/cards/cost-%s.png" % upgrade.exchange_cost)

func _process(delta: float) -> void:
	drop_shadow.shadow_offset.y = move_toward(drop_shadow.shadow_offset.y, 8 - target_y, animation_speed * delta)
	position.y = move_toward(position.y, target_y, animation_speed * delta)

func _on_toggled(value: bool) -> void:
	border.visible = value
	Events.exchange_card_select.emit(upgrade)

func _on_mouse_entered() -> void:
	target_y = -10
	Events.card_hover.emit(true, upgrade)

func _on_mouse_exited() -> void:
	target_y = 0
	Events.card_hover.emit(false, upgrade)
