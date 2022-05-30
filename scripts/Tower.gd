extends AOEBase
class_name Tower

func release():
	yield(get_tree().create_timer(1), "timeout")
	if _targets.size() < min_soak:
		for f in friendlies:
			f.take_damage(f.max_health)
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
