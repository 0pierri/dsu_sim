extends Node

var NPC = preload("res://scenes/Friendly.tscn")
onready var boss: Position3D = get_node("/root/Game/Boss")

signal loaded()

func _ready():
	for i in range(1,8):
		var npc = NPC.instance()
		npc.name = str(i)
		add_child(npc)
		npc.translate(Vector3(rand_range(-5, 5), 0, rand_range(-5, 5)))
		npc.look_at(Vector3(0,0,0), Vector3(0,1,0))
		npc.rotation.x = 0
		npc.rotation.z = 0
	emit_signal("loaded")
