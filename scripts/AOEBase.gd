extends Area
class_name AOEBase

var source: String
var target_name: String
var min_soak = 1
var damage = 1
var kb_distance
var kb_duration
var friendlies

var _targets = []

func check():
	for f in friendlies:
		var dist = f.global_transform.origin.distance_to(global_transform.origin)
		if dist < scale.x:
			#print("(" + target_name + ") Adding target " + f.name + "(" + str(dist) + ")")
			_targets.append(f)

func hit():
	for t in _targets:
		if t.name != target_name:
			#print("(" + target_name + ") Hitting " + t.name)
			if _targets.size() >= min_soak:
				t.take_damage(damage, source)
			else:
				t.take_damage(t.max_health, "%s (missing %s)" % [source, min_soak - _targets.size()])
			t.knockback(kb_distance, kb_duration, t.global_transform.origin - global_transform.origin)

func release():
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
