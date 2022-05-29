extends Container
class_name HealthBar

var friendly
var max_health
onready var child = get_node("Bar")
onready var SM = get_node("/root/Game/ScriptManager")

func _ready():
# warning-ignore:return_value_discarded
	SM.connect("reset", self, "_on_reset")
	
func setup(m, f):
	max_health = m
	friendly = f
	friendly.connect("health_changed", self, "_on_ScriptManager_health_changed")

func _on_ScriptManager_health_changed(health):
	child.value = health

func _on_reset():
	child.value = max_health
