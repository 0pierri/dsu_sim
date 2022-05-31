extends Label

func _ready():
	text = "Allow Death"

func _on_IgnoreDeathButton_pressed():
	text = "Ignore Death" if text == "Allow Death" else "Allow Death"
