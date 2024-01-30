extends Resource
class_name UpgradeResource

@export var name = ""
@export_multiline var description = ""
@export_range(1, 3) var cost = 1
@export var texture: Texture2D
@export var method: Upgrades.UPGRADES = Upgrades.UPGRADES.LIFE
