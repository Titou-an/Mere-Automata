extends KinematicBody

onready var camera = $RotationHelper/Camera
onready var rotattion_helper = $RotationHelper
onready var spawner = get_node("/root/Main/World/Spawner")

const MOV_SPD = 10

var vel = Vector3()
var v_mov := 0.0
var dir := Vector3()
var inputVec := Vector2()


var MOUSE_SENSITIVITY = 0.1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	process_input(delta)
	process_motion(delta)

func process_input(_delta):
	
	# Walking
	dir = Vector3()
	var cam_xform = self.get_global_transform()
	
	
	inputVec = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	) 
	
	inputVec = inputVec.normalized()
	
	v_mov = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	
	#dir += cam_xform.basis.y * inputVec.y
	
	dir += -cam_xform.basis.z * inputVec.y
	dir += cam_xform.basis.x * inputVec.x
	dir.y += v_mov
	
	
	# Hide user interface
	if Input.is_action_just_pressed("toggle_ui"):
		get_node("UI").visible = !get_node("UI").visible
	
	
func process_motion(_delta):
	 
	vel = Vector3.ZERO
	
	dir = dir.normalized()
	
	vel.x = dir.x * MOV_SPD / Engine.time_scale
	vel.z = dir.z * MOV_SPD / Engine.time_scale
	vel.y = dir.y * MOV_SPD * 0.5 / Engine.time_scale
	
	
	vel = move_and_slide(vel, Vector3.UP, false)
	

func _input(event):
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotattion_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
	
	var camera_rot = rotattion_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, -70, 70)
	rotattion_helper.rotation_degrees = camera_rot

