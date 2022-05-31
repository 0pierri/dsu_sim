extends Spatial

const friendlies = []

signal loaded(f)

func _on_loaded(f: Friendly):
	friendlies.append(f)
	if friendlies.size() == 8:
		emit_signal("loaded", friendlies)

func _on_apply_effect(effect, player, duration):
	friendlies[int(player)].apply_effect(effect, duration)

func _on_remove_effect(player):
	friendlies[int(player)].remove_effect()

func _on_apply_status(status, player, duration, show_timer):
	friendlies[int(player)].apply_status(status, duration, show_timer)

func _on_remove_status(status, player):
	friendlies[int(player)].remove_status(status)

func _on_remove_status_all(player):
	friendlies[int(player)].remove_status("")
	
func _on_IgnoreDeathButton_pressed():
	for f in friendlies:
		f.ignore_death = not f.ignore_death

func _on_reset():
	for f in friendlies:
		f.reset()
