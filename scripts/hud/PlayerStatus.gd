extends Status
class_name PlayerStatus

var hidden = true
var duration_remaining = 0

func set_timer(duration: float):
	duration_remaining = duration
	$MarginContainer/Label.text = str(ceil(duration))
	
func set_timer_shown(shown: bool):
	if shown:
		$MarginContainer/Label.show()
	else:
		$MarginContainer/Label.hide()

func _process(delta):
	duration_remaining = clamp(duration_remaining - delta, 0, duration_remaining)
	$MarginContainer/Label.text = str(ceil(duration_remaining))
