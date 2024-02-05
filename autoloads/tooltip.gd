extends PanelContainer
class_name Tooltip

@export var mouse_follow_speed = 10
@export var offset_amount = 20

@onready var tooltip := $Tooltip

func _ready() -> void:
	Events.card_hover.connect(_on_card_hover)
	visible = false
	Events.change_scene.connect(func(_scene): hide_tooltip())

func _process(delta: float) -> void:
	var target_position = Globals.mouse.position + Vector2.ONE * offset_amount
	if Globals.mouse.position.x > get_viewport_rect().size.x / 2:
		target_position.x -= offset_amount + size.x
	position = position.lerp(target_position, mouse_follow_speed * delta)

func show_tooltip(new_text: String):
	visible = true
	tooltip.text = new_text

func hide_tooltip():
	visible = false

func _on_card_hover(value: bool, upgrade: UpgradeResource, cannot_afford: bool):
	if value:
		var text = ""

		if cannot_afford: text = "\n\n[center][wave][i]You cannot afford this card[/i][/wave][/center]"
		else: text = "[wave][i]%s[/i][/wave]\n\n%s" % [upgrade.name, upgrade.description]

		show_tooltip(text)
	else:
		hide_tooltip()
