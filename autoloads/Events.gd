extends Node

signal card_select(upgrade: UpgradeResource)
signal card_deselect(upgrade: UpgradeResource)
signal card_hover(value: bool, upgrade: UpgradeResource, cannot_afford: bool)
signal go_in_portal(portal: Portal)
signal boss_defeated
signal change_scene(new_scene: PackedScene)
signal player_die
