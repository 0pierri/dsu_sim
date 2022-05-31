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

var HealthBarScene = preload("res://scenes/PartyHealthBar.tscn")
onready var TextureLoader = get_node("/root/Game/TextureLoader")
onready var Model = get_node("Model")
onready var Target = get_node("Target")
onready var Effect = get_node("Effect")
onready var PartyHealth = get_node("/root/Game/UI/Margin/Container/Left/PartyHealth")
onready var T = get_node("/root/Game/Timer")

signal health_changed(health)
signal loaded(f)

func _ready():
	get_node("CollisionArea").name = name
	health = max_health
		
	var hb = HealthBarScene.instance()
	hb.setup(max_health, self)
	PartyHealth.add_child(hb)
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
	Model.rotation.y = rad
	Target.rotation.y = rad
	
func take_damage(amount: float, source: String):	
	if health == 0:
		if just_died:
			death_recap.append([stepify(T.timer, 0.001), source])
			pass
		return
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health)
	Model.modulate = Color(1, 0.42, 0.42, 1)
	if health == 0:
		just_died = true
		death_recap.append([stepify(T.timer, 0.001), source])
		yield(get_tree().create_timer(0.2), "timeout")
		just_died = false
		var recap = name + " death recap:\n"
		for s in death_recap:
			recap += "[%s] %s\n" % [s[0], s[1]]
		print(recap)
		return
	yield(get_tree().create_timer(0.3), "timeout")
	Model.modulate = Color(1, 1, 1, 1)
	
func knockback(distance: float, duration: float, direction: Vector3):
	direction.y = 0
	# If new knockback, overwrite any existing ones
	if duration != 0:
		kb_duration = duration
		kb_vector = direction.normalized() * distance/duration
		
func apply_effect(effect: String, duration: float):
	Effect.texture = TextureLoader.get("tex_" + effect)
	Effect.show()
	yield(get_tree().create_timer(duration), "timeout")
	Effect.hide()
		
func remove_effect():
	Effect.hide()

func apply_status(_status: Texture, duration: float, show_timer: bool):
	pass

func remove_status(_status: Texture):
	pass

func reset():
	death_recap = []
	health = max_health
	kb_duration = 0
	Model.modulate = Color(1, 1, 1, 1)
