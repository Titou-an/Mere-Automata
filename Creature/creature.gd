extends KinematicBody

var rng = RandomNumberGenerator.new()
export var gravity := 9.8
export var speedWeight := 0.85
var bound_x = WorldGen.chunk_x * Hex_Chunk2.CHUNK_SIZE
var bound_z = (WorldGen.chunk_z * Hex_Chunk2.hex_offset * Hex_Chunk2.CHUNK_SIZE)

onready var vision = $Vision/CollisionShape
var vision_coll = CollisionShape.new()

export var species = 0
var diet = 0
export var vis_radius := 2.0
export var speed = 2

var fd_list = {}
var crt_list = {}
var target = Vector3()
var state = 0

var _velocity := Vector3()
var numb = 0
var jump = 5
var energy = 100

var timer = 0
var timer_limit = 2

var deg
onready var bar = $Sprite3D/Viewport/HealthBar2D

func _ready():
	rng.randomize()
	vis_radius = rng.randf_range(2,4)
	vision.shape = SphereShape.new()
	vision.shape.radius = vis_radius

func _physics_process(delta):
	
	# Decision Tree Based on Priority 
	
	# Dying from lack of energy
	if energy <= 0:
		death()
	
	# Dying from falling out of bound
	if self.transform.origin.y < 0:
		death()
	
	
	_velocity.y -= gravity * delta
	
	if is_on_wall():
		
		_velocity.y = jump
		moveCreature(numb)
		timer = 0

	if !crt_list.empty():
		var closest_crt = crt_list.keys()[0]
		
		if closest_crt.species == self.species:
			if energy > 70 and closest_crt.energy > 70:
				target = closest_crt.global_transform.origin
				
				_velocity.x = transform.origin.direction_to(target).x * speed
				_velocity.z = transform.origin.direction_to(target).z * speed
				rotateCreature(target)
#		else:
#			if diet != 0:
	if !fd_list.empty():
		
		#If there is food in the radius of the creature
		target = fd_list.values()[0]
		
		_velocity.x = transform.origin.direction_to(target).x * speed
		_velocity.z = transform.origin.direction_to(target).z * speed
		rotateCreature(target)
		
	else:
		
		
	# Nothing to do, move in a random direction
		if (timer > timer_limit):
			
			timer = 0
			rng.randomize()
			numb = round(rng.randi_range(0, 7))
			
			moveCreature(numb)
			
		if !((_velocity + transform.origin).x < bound_x and (_velocity + transform.origin).x > 0):
			_velocity.x = 0
		if !((_velocity + transform.origin).z < bound_z and (_velocity + transform.origin).z > 0):
			_velocity.z = 0
	
	timer += delta
	
	
	#Apply Motion
	
	_velocity.y = move_and_slide(_velocity, Vector3.UP).y
	
	# Energy update
	energy -= (speedWeight)/10
	energyUpdate()
	

func moveCreature(numb):
	#move in dir
#	if numb == 0:
#		x_mov = lerp(5, 0, speedWeight)
#		z_mov = 0
#
#	elif numb == 1:
#		z_mov = lerp(5, 0, speedWeight)
#		x_mov= 0
#
#	elif numb == 2:
#		x_mov = lerp(-5, 0, speedWeight)
#		z_mov = 0
#
#	elif numb == 3:
#		z_mov = lerp(-5, 0, speedWeight)
#		x_mov = 0
#
#	elif numb == 4:
#		x_mov = lerp((5 * sqrt(2)/2), 0, speedWeight)
#		z_mov = lerp((5 * sqrt(2)/2), 0, speedWeight)
#
#	elif numb == 5:
#		z_mov = lerp((5 * sqrt(2)/2), 0, speedWeight)
#		x_mov = lerp((-5 * sqrt(2)/2), 0, speedWeight)
#
#	elif numb == 6:
#		x_mov = lerp((5 * sqrt(2)/2), 0, speedWeight)
#		z_mov = lerp((-5 * sqrt(2)/2), 0, speedWeight)
#
#	else:
#		z_mov = lerp((-5 * sqrt(2)/2), 0, speedWeight)
#		x_mov = lerp((-5 * sqrt(2)/2), 0, speedWeight)
#
	var mov = (
		Vector2(1,0) if numb == 0 
		else Vector2(0,1) if numb == 1
		else Vector2(-1,0) if numb == 2
		else Vector2(0,-1) if numb == 3
		else Vector2(1,1) if numb == 4
		else Vector2(-1,1) if numb == 5
		else Vector2(1,-1) if numb == 6
		else Vector2(-1,-1) 
	)
	mov = mov.normalized() * speed
	_velocity.x = mov.x
	_velocity.z = mov.y
	
func rotateCreature(target):
	#rotate according to dir
#	deg = (
#		0 if numb == 0
#		else 270 if numb == 1
#		else 180 if numb == 2
#		else 90 if numb == 3
#		else 315 if numb == 4
#		else 225 if numb == 5
#		else 45 if numb == 6
#		else 135
#	)

	#lerp(self.rotation_degrees.y,deg,0.1)
	
	#rotation.y = lerp_angle(rotation.y,deg2rad(deg),0.1)
	
	var targ_rot = global_transform.origin.angle_to(target)
	rotation.y = lerp_angle(rotation.y, targ_rot,0.1)
	
func death():
	self.queue_free()

func energyUpdate():
	bar.update_bar(energy, 100)
	
func get_energy():
	return energy

func set_energy(energy):
	self.energy = energy

func remove_tg(area):
	fd_list.erase(area)
	

func _on_Vision_area_entered(area):
	fd_list[area] = area.global_transform.origin


func _on_Vision_area_exited(area):
	fd_list.erase(area)


func _on_Vision_body_entered(body):
	if body.is_in_group("creatures"):
		if body != self:
			crt_list[body] = body.global_transform.origin


func _on_Vision_body_exited(body):
	crt_list.erase(body)
