extends KinematicBody
class_name Friendly

var facing = 0
var max_health = 10
var flash_timer
var health

var kb_duration: float = 0
var kb_vector: Vector3
var just_died = false
var death_recap = []
var ignore_death = true
var statuses = {}
var healthbar: HealthBarWithStatus

var HealthBarScene = preload("res://scenes/PartyHealthBar.tscn")
onready var PartyHealth = get_node("/root/Game/UI/Margin/Container/Left/Party")
onready var T = get_node("/root/Game/Timer")
onready var TL = get_node("/root/Game/TextureLoader") as TextureLoader

signal health_changed(health)
signal loaded(f)

func _ready():
	get_node("CollisionArea").name = name
	health = max_health
		
	healthbar = HealthBarScene.instance()
	healthbar.setup(max_health, self)
	PartyHealth.add_child(healthbar)
	emit_signal("loaded", self)
	
func _physics_process(delta):
	if kb_duration > 0:
		kb_duration -= delta
# warning-ignore:return_value_discarded
		move_and_slide(kb_vector)
		
func get_rotation():
	return rotation.y + facing
	
func set_facing(rad: float):
	facing = rad
	$Model.rotation.y = rad
	$Target.rotation.y = rad
	
func take_damage(amount: float, type: String, source: String):	
	if health == 0:
		if just_died:
			death_recap.append([stepify(T.timer, 0.001), source])
		return
		
	if statuses.has("vuln_" + type):
		amount = max_health
	health = clamp(health - amount, 0, max_health)
	
	emit_signal("health_changed", health)
	$Model.modulate = Color(1, 0.42, 0.42, 1)
	# Delay for flashing red on damage
	if health > 0:
		yield(get_tree().create_timer(0.3), "timeout")
		if health > 0:
			# Only remove red if not dead after the delay
			$Model.modulate = Color(1, 1, 1, 1)
		# Only do the death recap for the killing blow, return otherwise
		return
	else:
		just_died = true
		death_recap.append([stepify(T.timer, 0.001), source])
		yield(get_tree().create_timer(0.2), "timeout")
		just_died = false
		var recap = name + "'s death recap:\n"
		for s in death_recap:
			recap += "[%s] %s\n" % [s[0], s[1]]
		print(recap)
	
func knockback(distance: float, duration: float, direction: Vector3):
	# If new knockback, overwrite any existing ones
	if duration != 0 and (ignore_death or health > 0):
		direction.y = 0
		kb_duration = duration
		kb_vector = direction.normalized() * distance/duration
		
func apply_effect(effect: String, duration: float):
	$Effect.texture = TL.get(effect)
	$Effect.show()
	yield(get_tree().create_timer(duration), "timeout")
	$Effect.hide()
		
func remove_effect():
	$Effect.hide()
	
func apply_status(status: String, duration: float, show_timer: bool):
	healthbar.apply_status(status, duration, show_timer)
	statuses[status] = duration

func remove_status(status: String):
	statuses.erase(status)
	healthbar.remove_status(status)
	
func remove_status_all():
	healthbar.remove_status_all()
	statuses.clear()

func reset():
	death_recap = []
	health = max_health
	kb_duration = 0
	$Model.modulate = Color(1, 1, 1, 1)
