extends CanvasLayer
class_name Exchange

enum STATE {
	EXCHANGE,
	CURRENT,
}

@export var tween_speed = 600
@export var exchange_panel_y = -270
@export var current_panel_y = 270

@onready var exchange_panel := $ExchangePanel
@onready var current_panel := $CurrentPanel
@onready var exchange_cards_row := $ExchangePanel/VerticalCenter/ExchangeCards
@onready var current_cards_row := $CurrentPanel/VerticalCenter/CurrentCards
@onready var card_name := $CardName
@onready var card_description := $CardDescription

var card_scene = preload("res://ui/card.tscn")
var state = STATE.EXCHANGE
var exchange_upgrade: UpgradeResource

func _ready() -> void:
	var upgrade_num = 5
	var random_upgrades = UpgradeManager.get_random_upgrades(upgrade_num)
	for i in range(upgrade_num):
		var card = card_scene.instantiate() as Card
		card.upgrade = random_upgrades[i]
		exchange_cards_row.add_child(card)

	var current_num = UpgradeManager.current_upgrades.size()
	for i in range(current_num):
		var card = card_scene.instantiate() as Card
		card.upgrade = UpgradeManager.current_upgrades[i]
		card.button_group = null
		current_cards_row.add_child(card)

	Events.exchange_card_select.connect(_on_exchange_card_select)
	Events.card_hover.connect(_on_card_hover)

func _process(delta: float) -> void:
	var exchange_panel_target = 0 if state == STATE.EXCHANGE else exchange_panel_y
	exchange_panel.position.y = move_toward(exchange_panel.position.y, exchange_panel_target, tween_speed * delta)

	var current_panel_target = 0 if state == STATE.CURRENT else current_panel_y
	current_panel.position.y = move_toward(current_panel.position.y, current_panel_target, tween_speed * delta)

func _on_exchange_card_select(upgrade: UpgradeResource):
	exchange_upgrade = upgrade
	state = STATE.CURRENT

func _on_card_hover(value: bool, upgrade: UpgradeResource):
	card_name.text = upgrade.name if value else ""
	card_description.text = upgrade.description if value else ""
