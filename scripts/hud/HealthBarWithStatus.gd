extends HealthBar
class_name HealthBarWithStatus

onready var TextureLoader = get_node("/root/Game/TextureLoader")
var Status = preload("res://scenes/Status.tscn")
var statuses = {}

func apply_status(status: String, duration: float, show_timer: bool):
	# Refresh if already exists
	if statuses.has(status):
		remove_status(status)
	var s = Status.instance()
	s.name = status
	s.set_texture(TextureLoader.get(status))
	statuses[status] = s
	add_child(s)
	
	yield(get_tree().create_timer(duration), "timeout")
	
	statuses.erase(status)
	if is_instance_valid(s) and not s.is_queued_for_deletion():
		s.queue_free()
		
func remove_status(status):
	var s = statuses.get(status)
	statuses.erase(status)
	remove_child(s)
	if is_instance_valid(s) and not s.is_queued_for_deletion():
		s.queue_free()

func remove_status_all():
	for s in statuses.keys():
		remove_status(s)
