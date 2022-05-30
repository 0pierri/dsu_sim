extends HBoxContainer

onready var TextureLoader = get_node("/root/Game/TextureLoader")
var PlayerStatus = preload("res://scenes/PlayerStatus.tscn")
var statuses = {}

func _on_apply_status(status: String, player: String, duration: float, show_timer: bool):
	if player == "0":
		var s = PlayerStatus.instance()
		s.name = status
		s.set_timer(duration)
		s.set_timer_shown(show_timer)
		s.set_texture(TextureLoader.get("tex_" + status))
		statuses[status] = s
		add_child(s)
		
		yield(get_tree().create_timer(duration), "timeout")
		
		statuses.erase(status)
		if is_instance_valid(s) and not s.is_queued_for_deletion():
			s.queue_free()

func _on_remove_status(status: String, player: String):
	if player == "0":
		var s = statuses.get(status)
		statuses.erase(status)
		s.queue_free()

func _on_remove_status_all(player: String):
		if player == "0":
			for s in statuses.values():
				statuses.erase(s.name)
				if is_instance_valid(s) and not s.is_queued_for_deletion():
					s.queue_free()
