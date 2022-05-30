extends Spatial

const friendlies = []

signal loaded(f)

func _on_loaded(f: Friendly):
	friendlies.append(f)
	if friendlies.size() == 8:
		emit_signal("loaded", friendlies)
