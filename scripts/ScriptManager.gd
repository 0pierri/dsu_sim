extends Node
class_name ScriptManager

const SCRIPT = [ # time is delay until the mechanic begins
	{"name": "Dive From Grace (markers)", "time": 1.0},
	{"name": "Dive From Grace (debuffs)", "time": 5.0},
	{"name": "Lash and Gnash", "time": 1.0},
	{"name": "First in Line (place) + Eye of the Tyrant", "time": 8.5},
	{"name": "Lash/Gnash (1st)", "time": 4.0},
	{"name": "Last/Gnash (2nd) + First in Line (soak)", "time": 2.0},
	{"name": "First in Line (bait)", "time": 2.0},
	{"name": "Second in Line (place)", "time": 1.0},
	{"name": "First in Line (Geirskogul)", "time": 2.0},
	{"name": "Lash and Gnash", "time": 1.0}, #duration 6s?
	{"name": "Second in Line (soak)", "time": 2.0},
	{"name": "Second in Line (bait)", "time": 1.0},
	{"name": "Third in Line", "time": 3.0},
	{"name": "Second in Line (Geirskogul) + Eye of the Tyrant", "time": 1.0},
	{"name": "Lash/Gnash (1st)", "time": 2.0},
	{"name": "Last/Gnash (2nd) + Third in Line (soak)", "time": 2.0},
	{"name": "Third in Line (bait)", "time": 1.0},
	{"name": "Autoattack", "time": 2.0},
	{"name": "Third in Line (Geirskogul)", "time": 1.0},
	{"name": "Drachenlance (cast)", "time": 3.0}, #3s
	{"name": "Drachenlance", "time": 3.0},
	{"name": "Finish", "time": 1.0}
]

signal toggle_pause()
signal reset()
signal mech_started(mech)
signal boss_cast(ability, length)

signal apply_effect(effect, player, duration)
signal remove_effect(player)
signal apply_status(status, player, duration, show_timer)
signal remove_status(status, player)
signal remove_status_all(player)

signal mech_dark_dive(type, player)
signal mech_eye()
signal mech_gnashlash(is_lash)
signal mech_towers()

var curr_mech
var next_mech_time
var lash

var players = ["0", "1", "2", "3", "4", "5", "6", "7"]
var dives = []
onready var AM = get_node("/root/Game/AOEManager") as AOEManager
onready var T = get_node("/root/Game/Timer")

func _ready():
	#get_viewport().debug_draw = 2
	randomize()
	reset()

func _physics_process(_delta):
	if T.timer >= next_mech_time:
		emit_signal("mech_started", SCRIPT[curr_mech]["name"])
		funcref(self, "mech_" + str(curr_mech)).call_func()
		curr_mech += 1
		next_mech_time += SCRIPT[curr_mech]["time"]

func _on_ResetButton_pressed():
	reset()
	
func reset():
	curr_mech = 0
	next_mech_time = SCRIPT[0]["time"]
	
	players.shuffle()
	var arrows = randi() % 2 == 0
	dives.append("spineshatter" if arrows else "highjump")
	dives.append("highjump")
	dives.append("elusive" if arrows else "highjump")
	arrows = randi() % 2 == 0
	dives.append("spineshatter" if arrows else "highjump")
	dives.append("elusive" if arrows else "highjump")
	arrows = randi() % 2 == 0
	dives.append("spineshatter" if arrows else "highjump")
	dives.append("highjump")
	dives.append("elusive" if arrows else "highjump")
	lash = randi() % 2 == 0
	
	for p in players:
		emit_signal("remove_effect", p)
		emit_signal("remove_status_all", p)
		
	players.remove(players.find("0"))
	players.push_front("0")
	dives[0] = "highjump"
	
	emit_signal("mech_started", "None")
	emit_signal("reset")
	
func mech_0():
	emit_signal("boss_cast", "Dive From Grace", 5)
	for i in range(0,3):
		emit_signal("apply_effect", "limitcut1", players[i], 5)
		emit_signal("apply_status", "first", players[i], 15.5, false)
	for i in range(3,5):
		emit_signal("apply_effect", "limitcut2_r", players[i], 5)
		emit_signal("apply_status", "second", players[i], 15.5, false)
	for i in range(5,8):
		emit_signal("apply_effect", "limitcut3", players[i], 5)
		emit_signal("apply_status", "third", players[i], 15.5, false)
	
func mech_1():
	for i in range(8):
		emit_signal("apply_status", dives[i], players[i], 9, true)
	
func mech_2():	
	emit_signal("boss_cast", "Lash and Gnash" if lash else "Gnash and Lash", 8)
	
func mech_3():
	for i in range(3):
		emit_signal("apply_status", "fireresdown", players[i], 12, true)
		emit_signal("apply_status", "physvulnup", players[i], 2, true)
		AM.mech_dark_dive(dives[i], players[i])
	AM.mech_eye()
	
func mech_4():
	AM.mech_towers()
	AM.mech_gnashlash(lash)
	
func mech_5():
	AM.mech_gnashlash(not lash)
	
func mech_23():
	pass
	reset()
