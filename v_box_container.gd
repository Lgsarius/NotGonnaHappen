extends VBoxContainer

func _ready():
	var button = Button.new()
	button.text = "Click me"
	add_child(button)
	button.pressed.connect(_on_button_pressed)
	print("Button added")

func _on_button_pressed():
	print("Button clicked!")
