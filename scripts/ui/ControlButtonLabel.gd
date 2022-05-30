extends Label

func _ready():
	text = "Legacy"

func _on_ControlButton_pressed():
	text = "Standard" if text == "Legacy" else "Legacy"
