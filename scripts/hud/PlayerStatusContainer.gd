extends HBoxContainer
class_name PlayerStatuses

var PlayerStatus = preload("res://scenes/PlayerStatus.tscn")
var statuses = {}

onready var TL = get_node("/root/Game/TextureLoader") as TextureLoader

func apply_status(status: String, duration: float, show_timer: bool):
	var s = PlayerStatus.instance()
	s.name = status
	s.set_timer(duration)
	s.set_timer_shown(show_timer)
	s.set_texture(TL.get(status))
	statuses[status] = s
	add_child(s)
	
	yield(get_tree().create_timer(duration), "timeout")
	
	statuses.erase(status)
	if is_instance_valid(s) and not s.is_queued_for_deletion():
		s.queue_free()

func remove_status(status: String):
	var s = statuses.get(status)
	statuses.erase(status)
	remove_child(s)
	if is_instance_valid(s) and not s.is_queued_for_deletion():
		s.queue_free()

func remove_status_all():
	for s in statuses.keys():
		remove_status(s)
