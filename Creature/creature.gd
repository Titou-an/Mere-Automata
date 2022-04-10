extends KinematicBody

var rng = RandomNumberGenerator.new()
export var gravity := 9.8
export var speedWeight := 0.85
var speed = 2

var targ_list = {}
var target = Vector3()

var _velocity := Vector3()
var numb = 0
var jump = 5
var energy = 100

var timer = 0
var timer_limit = 2

var deg
onready var bar = $Sprite3D/Viewport/HealthBar2D

func _physics_process(delta):
	
	target = null
	
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
	
	
	if !targ_list.empty():
		#If there is  food in the vision of the creature
		target = targ_list.values()[0]
		
		_velocity.x = transform.origin.direction_to(target).x * speed
		_velocity.z = transform.origin.direction_to(target).z * speed
		
		rotation.y = lerp_angle(rotation.y,transform.origin.angle_to(target),0.2)
		
	else:
		if (timer > timer_limit):
			# Nothing to do, move in a random direction
			timer = 0
			rng.randomize()
			numb = round(rng.randi_range(0, 7))
			
			moveCreature(numb)
		
		timer += delta
	
	#Apply Motion
	#rotateCreature(numb)
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
	# Energy update
	energy -= speedWeight/10
	energyUpdate()
	

func moveCreature(numb):
	#move in dir
		if numb == 0:
			_velocity.x = lerp(5, 0, speedWeight)
			_velocity.z = 0
			
		elif numb == 1:
			_velocity.z = lerp(5, 0, speedWeight)
			_velocity.x = 0
			
		elif numb == 2:
			_velocity.x = lerp(-5, 0, speedWeight)
			_velocity.z = 0
			
		elif numb == 3:
			_velocity.z = lerp(-5, 0, speedWeight)
			_velocity.x = 0
			
		elif numb == 4:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.z = lerp((5 * sqrt(2)/2), 0, speedWeight)
			
		elif numb == 5:
			_velocity.z = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		elif numb == 6:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		else:
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		
func rotateCreature(numb):
	#rotate according to dir
	deg = (
		0 if numb == 0
		else 270 if numb == 1
		else 180 if numb == 2
		else 90 if numb == 3
		else 315 if numb == 4
		else 225 if numb == 5
		else 45 if numb == 6
		else 135
	)
	#lerp(self.rotation_degrees.y,deg,0.1)
	self.rotation.y = lerp_angle(rotation.y,deg2rad(deg),0.1)
	
func death():
	self.queue_free()

func energyUpdate():
	bar.update_bar(energy, 100)
	
func get_energy():
	return energy

func set_energy(energy):
	self.energy = energy

func remove_tg(area):
	targ_list.erase(area)
	

func _on_Vision_area_entered(area):
	targ_list[area] = area.global_transform.origin


func _on_Vision_area_exited(area):
	targ_list.erase(area)
