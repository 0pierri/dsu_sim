extends Spatial
class_name Friendlies

const friendlies = []

onready var PS = get_node("/root/Game/PlayerStatus/Statuses") as PlayerStatuses

signal loaded(f)

func _on_loaded(f: Friendly):
	friendlies.append(f)
	if friendlies.size() == 8:
		emit_signal("loaded", friendlies)
	
func _on_IgnoreDeathButton_pressed():
	for f in friendlies:
		f.ignore_death = not f.ignore_death

func _on_reset():
	for f in friendlies:
		f.reset()

func apply_effect(effect: String, friendly: String, duration: float):	
	friendlies[int(friendly)].apply_effect(effect, duration)

func remove_effect(friendly: String):
	friendlies[int(friendly)].remove_effect()

func apply_status(status: String, friendly: String, duration: float, show_timer: bool):
	friendlies[int(friendly)].apply_status(status, duration, show_timer)
	if friendly == "0":
		PS.apply_status(status, duration, show_timer)

func remove_status(status: String, friendly: String):
	friendlies[int(friendly)].remove_status(status)
	if friendly == "0":
		PS.remove_status(status)

func remove_status_all(friendly: String):
	friendlies[int(friendly)].remove_status_all()
	if friendly == "0":
		PS.remove_status_all()
