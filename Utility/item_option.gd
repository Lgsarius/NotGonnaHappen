extends Panel

@onready var game = get_tree().get_first_node_in_group("Game")

signal selected_upgrade()

func _ready():
	connect("selected_upgrade",Callable(game,"upgrade_character"))
	





func _on_button_pressed() -> void:
	selected_upgrade.emit()
