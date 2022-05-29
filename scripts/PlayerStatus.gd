extends HBoxContainer

onready var TextureLoader = get_node("/root/Game/TextureLoader")
var Status = preload("res://scenes/Status.tscn")
var statuses = {}

func _on_apply_status(status: String, player: String):
	if player == "0":
		var s = Status.instance()
		s.name = status
		s.get_node("Texture").texture = TextureLoader.get_texture(status)
		s.rect_min_size *= 2
		statuses[status] = s
		add_child(s)

func _on_remove_status(status: String, player: String):
	if player == "0":
		var s = statuses.get(status)
		statuses.erase(status)
		remove_child(s)
		s.queue_free()

func _on_remove_status_all(player: String):
		if player == "0":
			for s in statuses.values():
				statuses.erase(s.name)
				remove_child(s)
				s.queue_free()
