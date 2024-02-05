extends CanvasLayer
class_name Exchange

enum STATE {
	EXCHANGE,
	SHOP,
	FINISHED,
}

@export var tween_speed = 6

@onready var existing_panel := $ExistingPanel
@onready var shop_panel := $ShopPanel
@onready var existing_cards_row := $ExistingPanel/VerticalCenter/ExistingCards
@onready var shop_cards_row := $ShopPanel/VerticalCenter/ShopCards
@onready var continue_button := $ExistingPanel/ContinueButton
@onready var exchange_label := $ExchangeLabel
@onready var exchange_text := $ExchangeLabel/ExchangeText
@onready var exchange_label_cost_icon := $ExchangeLabel/CostIcon
@onready var cost_label := $ShopPanel/CostLabel

var card_scene = preload("res://ui/card.tscn")
var state = STATE.EXCHANGE
var shop_upgrade_selected: UpgradeResource
var existing_upgrades_selected: Array[UpgradeResource]

func _ready() -> void:
	# Get 1 new random upgrade
	var new_random_upgrade = UpgradeManager.get_random_upgrades(1)[0]
	UpgradeManager.current_upgrades.push_back(new_random_upgrade)

	# You current existing cards
	var current_num = len(UpgradeManager.current_upgrades)
	for i in range(current_num):
		var card = card_scene.instantiate() as Card
		card.upgrade = UpgradeManager.current_upgrades[i]
		card.button_group = null
		if i == current_num - 1: card.is_new = true
		existing_cards_row.add_child(card)

	Events.card_select.connect(_on_card_select)
	Events.card_deselect.connect(_on_card_deselect)

	exchange_label_cost_icon.visible = false

func _process(delta: float) -> void:
	var existing_panel_target_y = 0.0 if state == STATE.EXCHANGE else -270.0
	existing_panel.position.y = lerp(existing_panel.position.y, existing_panel_target_y, tween_speed * delta)

	var shop_panel_target_y = 0.0 if state == STATE.SHOP else 270.0
	shop_panel.position.y = lerp(shop_panel.position.y, shop_panel_target_y, tween_speed * delta)

func get_selected_existing_cards_cost():
	var cost = 0
	for upgrade in existing_upgrades_selected:
		cost += upgrade.cost
	return cost

func get_selected_shop_card():
	for card in shop_cards_row.get_children():
		if card.button_pressed: return card

func get_selected_existing_cards():
	var result: Array[Card] = []
	for card in existing_cards_row.get_children():
		if card.button_pressed: result.push_back(card)
	return result

func update_continue_button():
	continue_button.disabled = len(existing_upgrades_selected) < 1

func create_shop_cards():
	# Random cards in the shop
	var shop_upgrade_num = 5
	var random_upgrades = UpgradeManager.get_random_upgrades(shop_upgrade_num - 1)
	random_upgrades.push_back((UpgradeManager.get_random_upgrades(1, 1)[0]))
	for upgrade in random_upgrades:
		var card = card_scene.instantiate() as Card
		card.upgrade = upgrade
		card.is_disabled = get_selected_existing_cards_cost() < upgrade.cost
		shop_cards_row.add_child(card)

func update_cost_label():
	cost_label.text = "[center][i]You have %s   to spend[/i]\n Any extra   will be counted as a bonus in scoring" % get_selected_existing_cards_cost()

func finish():
	# Disabled all cards
	for card in existing_cards_row.get_children(): card.disabled = true
	for card in shop_cards_row.get_children(): card.disabled = true

	# Exchanging the cards in upgrade manager
	UpgradeManager.current_upgrades.push_back(shop_upgrade_selected)
	for upgrade in existing_upgrades_selected:
		var index = UpgradeManager.current_upgrades.find(upgrade)
		if index != -1: UpgradeManager.current_upgrades.remove_at(index)

	UpgradeManager.activate_all_upgrades()

	# Extra cost bonus
	var text = "[center][wave]EXCHANGE![/wave]"
	if get_selected_existing_cards_cost() > shop_upgrade_selected.cost:
		var extra = get_selected_existing_cards_cost() - shop_upgrade_selected.cost
		Scoring.extra_cost_bonus += extra
		exchange_label_cost_icon.visible = true
		text += "\n[i]You still had %s   left over, and will counted as a bonus in scoring" % extra
	exchange_text.text = text

	# Animation stuff
	var tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_BACK)

	tween.tween_interval(0.5)
	tween.chain().tween_property($ExistingPanel/VerticalCenter, "global_position", Vector2(0, 48 - 38), 1.0)
	tween.tween_property($ShopPanel/VerticalCenter, "global_position", Vector2(0, 222 - 76), 1.0)
	tween.tween_property(exchange_label, "global_position", Vector2(0, exchange_label.position.y), 1.0)

	tween.tween_interval(2.0)
	var shop_card = get_selected_shop_card()
	tween.chain().tween_callback(func():
		shop_cards_row.remove_child(shop_card)
		existing_cards_row.add_child(shop_card)
	)

	var selected_cards = get_selected_existing_cards()
	for card in selected_cards:
		tween.tween_callback(func():
			existing_cards_row.remove_child(card)
			shop_cards_row.add_child(card)
		)

	tween.chain().tween_callback(SceneManager.next_level).set_delay(1.0)

func _on_card_select(upgrade: UpgradeResource):
	if state == STATE.EXCHANGE:
		existing_upgrades_selected.push_back(upgrade)
		update_continue_button()
	elif state == STATE.SHOP:
		shop_upgrade_selected = upgrade
		state = STATE.FINISHED
		finish()

func _on_card_deselect(upgrade: UpgradeResource):
	if state == STATE.EXCHANGE:
		var index = existing_upgrades_selected.find(upgrade)
		if index != -1: existing_upgrades_selected.remove_at(index)
		update_continue_button()
	elif state == STATE.SHOP:
		shop_upgrade_selected = null

func _on_continue_button_pressed() -> void:
	state = STATE.SHOP
	update_cost_label()
	create_shop_cards()
