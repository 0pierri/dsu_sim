extends Spatial

var config = ConfigFile.new()

const CAMERA_X_ROT_MIN = -89.9
const CAMERA_X_ROT_MAX = 70.0
const DISTANCE_MIN = 2
const DISTANCE_MAX = 16
const TILT_MIN = 0
const TILT_MAX = 0.65

var standard_controls = true
var camera_x_rot = 0.0

var mouse_pos = Vector2(0,0)
var drag_r = false
var drag_l = false

var tilt = 0.0
var V_SENS
var H_SENS

onready var player = get_node(@"/root/Game/Friendlies/0")
onready var camera_tilt = get_node(@"CameraTilt")

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = config.load("user://config.cfg")
	if err != OK:
		# Defaults
		config.set_value("Camera", "tilt", 0.0)
		config.set_value("Camera", "distance", 0)
		config.set_value("Camera", "v_sensitivity", 5)
		config.set_value("Camera", "h_sensitivity", 5)
		config.save("user://config.cfg")
		
	camera_tilt.rotation.x = clamp(config.get_value("Camera", "tilt"), TILT_MIN, TILT_MAX)
	camera_tilt.translation.z = clamp(config.get_value("Camera", "distance"), DISTANCE_MIN, DISTANCE_MAX)
	V_SENS = clamp(config.get_value("Camera", "v_sensitivity"), 1, 10)
	H_SENS = clamp(config.get_value("Camera", "h_sensitivity"), 1, 10)
	
func _process(_delta):
	camera_tilt.rotation.x = clamp(camera_tilt.rotation.x + tilt, TILT_MIN, TILT_MAX)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_LEFT:
			if event.pressed:
				if not drag_r and not drag_l:
					mouse_pos = event.position					
				drag_r = drag_r or event.button_index == BUTTON_RIGHT
				drag_l = drag_l or event.button_index == BUTTON_LEFT
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				drag_r = drag_r && event.button_index != BUTTON_RIGHT
				drag_l = drag_l && event.button_index != BUTTON_LEFT
				if not drag_r and not drag_l:					
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					get_viewport().warp_mouse(mouse_pos)
					
		elif event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN:
			var dir = -0.2 if event.button_index == BUTTON_WHEEL_UP else 0.2
			camera_tilt.translation.z = clamp(camera_tilt.translation.z + dir, DISTANCE_MIN, DISTANCE_MAX)
			config.set_value("Camera", "distance", camera_tilt.translation.z)
			config.save("user://config.cfg")
			
	elif event is InputEventMouseMotion:
		if drag_r or drag_l:
			camera_x_rot += event.relative.y / get_viewport().size.y * -deg2rad(180) * 0.1*V_SENS
			camera_x_rot = clamp(camera_x_rot, deg2rad(CAMERA_X_ROT_MIN), deg2rad(CAMERA_X_ROT_MAX))
			rotation.x = (camera_x_rot)
			if drag_r or not standard_controls:
				# Reset player rotation to face camera direction
				if rotation.y != 0:
					player.rotate_y(rotation.y)
					rotation.y = 0
					orthonormalize()
				# Then rotate
				player.rotate_y(-event.relative.x * 0.001*H_SENS)
			elif drag_l:
				rotate_y(-event.relative.x * 0.001*H_SENS)
				orthonormalize()
		
	if event.is_action_pressed("ui_up"):
		tilt = deg2rad(1) * 0.1
	elif event.is_action_pressed("ui_down"):
		tilt = deg2rad(-1) * 0.1
	elif event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		tilt = 0
		config.set_value("Camera", "tilt", camera_tilt.rotation.x)
		config.save("user://config.cfg")		


func _on_ControlButton_pressed():
	standard_controls = not standard_controls
