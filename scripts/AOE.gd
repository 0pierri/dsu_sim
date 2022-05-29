extends Area

var _done = false
var target = null
var damage = 1
var kb_distance
var kb_duration

func _physics_process(delta):
	if not _done:
		for a in get_overlapping_areas():
			_done = true
			if a.get_parent().name != target:
				a.get_parent().take_damage(damage)
			a.get_parent().knockback(kb_distance, kb_duration, a.get_parent().global_transform.origin - global_transform.origin)
