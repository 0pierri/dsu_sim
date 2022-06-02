extends Area
class_name AOEBase

var source: String
var damage_type: String
var target_name: String
var min_soak = 1
var damage = 1
var kb_distance
var kb_duration
var statuses: Dictionary

var _targets = []
onready var F = get_node("/root/Game/Friendlies") as Friendlies

func check():
	for f in F.friendlies:
		if f.health > 0 or f.ignore_death:
			var dist = f.global_transform.origin.distance_to(global_transform.origin)
			if dist < scale.x:
				_targets.append(f)

func hit():
	for t in _targets:
		if t.name != target_name:
			#print("(" + target_name + ") Hitting " + t.name)
			if _targets.size() >= min_soak:
				t.take_damage(damage, damage_type, source)
			else:
				t.take_damage(t.max_health, damage_type, "%s (missing %s)" % [source, min_soak - _targets.size()])
			t.knockback(kb_distance, kb_duration, t.global_transform.origin - global_transform.origin)
		for s in statuses.keys():
			F.apply_status(s, t.name, statuses[s], true)

func release():
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
