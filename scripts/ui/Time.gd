extends Label

func _on_ScriptManager_timer_changed(timer):
	text = "Time: " + str(stepify(timer, 0.01)).pad_decimals(2)
