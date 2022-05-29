extends Node

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
signal timer_changed(timer)
signal mech_started(mech)
signal boss_cast(ability, length)
signal damage(players, ability, amount)

signal apply_effect(effect, player)
signal remove_effect(player)
signal apply_status(status, player)
signal remove_status(status, player)
signal remove_status_all(player)

signal mech_dark_dive(type, player)
signal mech_eye()
signal mech_gnashlash(is_lash)

var timer = 0
var started
var curr_mech
var next_mech_time
var lash

var players = ["0", "1", "2", "3", "4", "5", "6", "7"]
var dives = []

func _ready():
	#get_viewport().debug_draw = 2
	randomize()
	reset()

func _process(delta):
	if !started:
		return
		
	timer += delta
	emit_signal("timer_changed", timer)
	
	if timer >= next_mech_time:
		emit_signal("mech_started", SCRIPT[curr_mech]["name"])
		funcref(self, "mech_" + str(curr_mech)).call_func()
		curr_mech += 1
		next_mech_time += SCRIPT[curr_mech]["time"]
		
func _on_StartButton_button_pressed(state):
	started = state == "Start"
	emit_signal("toggle_pause")
	
func _on_ResetButton_pressed():
	reset()
	
func reset():
	started = false
	timer = 0
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
	dives[0] = "elusive"
	
	emit_signal("timer_changed", timer)
	emit_signal("mech_started", "None")	
	emit_signal("reset")
	
func mech_0():
	emit_signal("boss_cast", "Dive From Grace", 5)
	for i in range(0,3):
		emit_signal("apply_effect", "limitcut1", players[i])
		emit_signal("apply_status", "first", players[i])
	for i in range(3,5):
		emit_signal("apply_effect", "limitcut2_r", players[i])
		emit_signal("apply_status", "second", players[i])
	for i in range(5,8):
		emit_signal("apply_effect", "limitcut3", players[i])
		emit_signal("apply_status", "third", players[i])
	
func mech_1():
	for i in range(8):
		emit_signal("remove_effect", players[i])
		emit_signal("apply_status", dives[i], players[i])
	
func mech_2():	
	emit_signal("boss_cast", "Lash and Gnash" if lash else "Gnash and Lash", 8)
	
func mech_3():
	for i in range(3):
		emit_signal("remove_status_all", players[i])
		emit_signal("apply_status", "fireresdown", players[i])
		emit_signal("apply_status", "physvulnup", players[i])
		emit_signal("mech_dark_dive", dives[i], players[i])
	emit_signal("mech_eye")
	
func mech_4():
	emit_signal("mech_gnashlash", lash)
	
func mech_5():
	emit_signal("mech_gnashlash", not lash)
	
func mech_23():
	pass
	reset()
