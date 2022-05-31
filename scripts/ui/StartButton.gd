extends TextureButton

var state = "Start"

signal button_pressed(state)

func _on_StartButton_pressed():
	state = "Pause" if state == "Start" else "Start"	
	get_node("Label").text = state


func _on_ResetButton_pressed():
	state = "Start"
	get_node("Label").text = state
