extends Panel


@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblLevel = $lbl_level
@onready var itemIcon = $ColorRect/ItemIcon

@onready var player = get_tree().get_first_node_in_group("Player")


var item = null
signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade",Callable(player,"upgrade_character"))
	if item == null:
		item = "food"
	lblName.text = UpgradeDb.UPGRADES[item]["displayname"]
	lblDescription.text  =UpgradeDb.UPGRADES[item]["details"]
	lblLevel.text = UpgradeDb.UPGRADES[item]["level"]
	#itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])





func _on_button_pressed() -> void:
	selected_upgrade.emit(item)
