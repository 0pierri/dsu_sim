extends HealthBar

onready var TextureLoader = get_node("/root/Game/TextureLoader")
var Status = preload("res://scenes/Status.tscn")
var statuses = {}

func _ready():
	SM.connect("apply_status", self, "_on_apply_status")
	SM.connect("remove_status_all", self, "_on_remove_status_all")

func _on_apply_status(status: String, player: String, duration: float, show_timer: bool):
	if player == friendly.name:
		var s = Status.instance()
		s.name = status
		s.set_texture(TextureLoader.get("tex_" + status))
		statuses[status] = s
		add_child(s)
		
		yield(get_tree().create_timer(duration), "timeout")
		
		statuses.erase(status)
		if is_instance_valid(s) and not s.is_queued_for_deletion():
			s.queue_free()

func _on_remove_status_all(player: String):
	if player == friendly.name:
		for s in statuses.values():
			statuses.erase(s.name)
			remove_child(s)
			if is_instance_valid(s) and not s.is_queued_for_deletion():
				s.queue_free()
