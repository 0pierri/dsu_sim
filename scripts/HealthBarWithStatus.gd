extends HealthBar

onready var TextureLoader = get_node("/root/Game/TextureLoader")
var Status = preload("res://scenes/Status.tscn")
var statuses = {}

func _ready():
	SM.connect("apply_status", self, "_on_apply_status")
	SM.connect("remove_status", self, "_on_remove_status")
	SM.connect("remove_status_all", self, "_on_remove_status_all")

func _on_apply_status(status: String, player: String):
	if player == friendly.name:
		var s = Status.instance()
		s.name = status
		s.get_node("Texture").texture = TextureLoader.get_texture(status)
		statuses[status] = s
		add_child(s)
	
func _on_remove_status(status: String, player: String):
	if player == friendly.name:
		var s = statuses.get(status)
		statuses.erase(status)
		remove_child(s)
		s.queue_free()

func _on_remove_status_all(player: String):
	if player == friendly.name:
		for s in statuses.values():
			statuses.erase(s.name)
			remove_child(s)
			s.queue_free()
