extends CanvasLayer
class_name Exchange

enum STATE {
	EXCHANGE,
	CURRENT,
	FINISHED,
}

@export var tween_speed = 6
@export var exchange_panel_y = -270.0
@export var current_panel_y = 270.0
@export var cost_texture: Texture2D
@export var cost_filled: Texture2D
@export var cost_extra: Texture2D

@onready var exchange_panel := $ExchangePanel
@onready var current_panel := $CurrentPanel
@onready var exchange_cards_row := $ExchangePanel/VerticalCenter/ExchangeCards
@onready var current_cards_row := $CurrentPanel/VerticalCenter/CurrentCards
@onready var cost_row := $CurrentPanel/Cost
@onready var back_button := $CurrentPanel/BackButton
@onready var continue_button := $CurrentPanel/ContinueButton
@onready var current_panel_instructions := $CurrentPanel/Instructions

var card_scene = preload("res://ui/card.tscn")
var state = STATE.EXCHANGE
var exchange_upgrade: UpgradeResource
var selected_upgrades: Array[UpgradeResource]

func _ready() -> void:
	var upgrade_num = 5
	var random_upgrades = UpgradeManager.get_random_upgrades(upgrade_num)
	for i in range(upgrade_num):
		var card = card_scene.instantiate() as Card
		card.upgrade = random_upgrades[i]
		exchange_cards_row.add_child(card)

	var new_random_upgrade = UpgradeManager.get_random_upgrades(1)[0]
	UpgradeManager.current_upgrades.push_back(new_random_upgrade)
	UpgradeManager.activate_upgrade(new_random_upgrade.method)

	var current_num = len(UpgradeManager.current_upgrades)
	for i in range(current_num):
		var card = card_scene.instantiate() as Card
		card.upgrade = UpgradeManager.current_upgrades[i]
		card.button_group = null
		current_cards_row.add_child(card)

	Events.exchange_card_select.connect(_on_exchange_card_select)
	Events.exchange_card_deselect.connect(_on_exchange_card_deselect)

func _process(delta: float) -> void:
	var exchange_panel_target = 0.0 if state == STATE.EXCHANGE else exchange_panel_y
	exchange_panel.position.y = lerp(exchange_panel.position.y, exchange_panel_target, tween_speed * delta)

	var current_panel_target = 0.0 if state == STATE.CURRENT or state == STATE.FINISHED else current_panel_y
	current_panel.position.y = lerp(current_panel.position.y, current_panel_target, tween_speed * delta)

func update_cost_ui():
	var selected_cost = get_selected_cards_cost()
	for cost_ui in cost_row.get_children():
		cost_ui.texture = null
		cost_ui.visible = false

	for i in range(exchange_upgrade.cost):
		var cost_ui = cost_row.get_child(i) as TextureRect
		if cost_ui:
			cost_ui.visible = true
			if i < selected_cost:
				cost_ui.texture = cost_filled
			else:
				cost_ui.texture = cost_texture

			if selected_cost > exchange_upgrade.cost:
				cost_row.get_child(3).visible = true
				cost_row.get_child(3).texture = cost_extra

	if selected_cost >= exchange_upgrade.cost:
		continue_button.disabled = false
	else:
		continue_button.disabled = true

func get_selected_cards_cost():
	var cost = 0
	for upgrade in selected_upgrades:
		cost += upgrade.cost
	return cost

func get_exchange_card():
	for card in exchange_cards_row.get_children():
		if card.button_pressed: return card

func get_selected_cards():
	var result: Array[Card] = []
	for card in current_cards_row.get_children():
		if card.button_pressed: result.push_back(card)
	return result

func _on_exchange_card_select(upgrade: UpgradeResource):
	if state == STATE.EXCHANGE:
		exchange_upgrade = upgrade
		state = STATE.CURRENT
		update_cost_ui()
	elif state == STATE.CURRENT:
		selected_upgrades.push_back(upgrade)
		print(selected_upgrades)
		update_cost_ui()

func _on_exchange_card_deselect(upgrade: UpgradeResource):
	if state == STATE.CURRENT:
		var upgrade_index = selected_upgrades.find(upgrade)
		if upgrade_index != -1:
			selected_upgrades.remove_at(upgrade_index)
			print(selected_upgrades)
			update_cost_ui()

func _on_back_button_pressed() -> void:
	state = STATE.EXCHANGE

func _on_continue_button_pressed() -> void:
	state = STATE.FINISHED

	for card in current_cards_row.get_children():
		card.disabled = true

	UpgradeManager.current_upgrades.push_back(exchange_upgrade)
	for upgrade in selected_upgrades:
		var index = UpgradeManager.current_upgrades.find(upgrade)
		if index != -1:
			UpgradeManager.current_upgrades.remove_at(index)

	UpgradeManager.activate_upgrade(exchange_upgrade.method)
	for upgrade in selected_upgrades:
		UpgradeManager.deactivate_upgrade(upgrade.method)

	var tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_BACK)
	tween.tween_property(continue_button, "position", Vector2(0, 100), 1.0).as_relative()
	tween.tween_property(back_button, "position", Vector2(0, 100), 1.0).as_relative()
	tween.tween_property(cost_row, "position", -Vector2(0, 100), 1.0).as_relative()
	tween.tween_property(current_panel_instructions, "position", -Vector2(0, 60), 1.0).as_relative()
	tween.tween_property($CurrentPanel/VerticalCenter, "global_position", Vector2(0, 200 - 54), 1.0)
	tween.tween_property($ExchangePanel/VerticalCenter, "global_position", Vector2(0, 70 - 54), 1.0)

	var exchange_card = get_exchange_card()
	tween.chain().tween_callback(func():
		exchange_cards_row.remove_child(exchange_card)
		current_cards_row.add_child(exchange_card)
	)

	var selected_cards = get_selected_cards()
	for card in selected_cards:
		tween.tween_callback(func():
			current_cards_row.remove_child(card)
			exchange_cards_row.add_child(card)
		)

	tween.chain().tween_property($CurrentPanel/VerticalCenter, "global_position", Vector2(0, 270), 1.0).set_delay(1.0)
	tween.tween_property($ExchangePanel/VerticalCenter, "global_position", Vector2(0, 0 - 108), 1.0).set_delay(1.0)

	tween.tween_callback(SceneManager.next_level).set_delay(1.0)

