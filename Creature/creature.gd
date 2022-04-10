extends KinematicBody

var rng = RandomNumberGenerator.new()
export var gravity := 9.8
export var speedWeight := 0.85

var targ_list = {}

var _velocity := Vector3()
var numba = 0
var jump = 5
var energy = 100
var enConv
var timer = 0
var timer_limit = 2
var deg
onready var bar = $Sprite3D/Viewport/HealthBar2D

func _physics_process(delta):
	if energy <= 0:
		death()
	
	if self.transform.origin.y < 0:
		death()
	
	
	
	enConv = energy
	energy -= speedWeight/10
	energyUpdate()
	
	_velocity.y -= gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
	if is_on_wall():
		
		_velocity.y = jump
		moveCreature(numba)
		timer = 0
	
	timer += delta
	
	rotateCreature(numba)
	
	#Nothing to do, move in a random direction
	if (timer > timer_limit):
		
		timer = 0
		rng.randomize()
		numba = round(rng.randf_range(0, 7))
		moveCreature(numba)
		
	
func moveCreature(numba):
	#move in dir
		if numba == 0:
			_velocity.x = lerp(5, 0, speedWeight)
			_velocity.z = 0
			
		if numba == 1:
			_velocity.z = lerp(5, 0, speedWeight)
			_velocity.x = 0
			
		if numba == 2:
			_velocity.x = lerp(-5, 0, speedWeight)
			_velocity.z = 0
			
		if numba == 3:
			_velocity.z = lerp(-5, 0, speedWeight)
			_velocity.x = 0
			
		if numba == 4:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.z = lerp((5 * sqrt(2)/2), 0, speedWeight)
			
		if numba == 5:
			_velocity.z = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		if numba == 6:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, speedWeight)
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		if numba == 7:
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, speedWeight)
			
		
func rotateCreature(numba):
	#rotate according to dir
	if numba == 0:
		deg = 0
	if numba == 1:
		deg = 270
	if numba == 2:
		deg = 180
	if numba == 3:
		deg = 90
	if numba == 4:
		deg = 315
	if numba == 5:
		deg = 225
	if numba == 6:
		deg = 45
	if numba == 7:
		deg = 135
	#lerp(self.rotation_degrees.y,deg,0.1)
	self.rotation_degrees.y = rad2deg(lerp_angle(deg2rad(self.rotation_degrees.y),deg2rad(deg),0.1))
	
func death():
	self.queue_free()

func energyUpdate():
	bar.update_bar(energy, 100)
	


func _on_Area_area_entered(area):
	targ_list[area] = area.global_transform.origin
	
