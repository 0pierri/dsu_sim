extends AOEBase
class_name Donut

func check():
	for f in friendlies:
		var dist = f.global_transform.origin.distance_to(global_transform.origin)
		if dist > scale.x:
			_targets.append(f)
