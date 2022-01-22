extends KinematicBody
var rng = RandomNumberGenerator.new()
export var gravity := 9.8
var _velocity := Vector3()
var numba
var timer = 0
var timer_limit = 2
func _ready():
	print("sup")
	
	
	
func _physics_process(delta):
	
	if not is_on_floor():
		_velocity.y -= gravity * delta
	
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
	
	timer += delta
	
	#Nothing to do, move in a random direction
	
	if (timer > timer_limit):
		
		timer = 0
		rng.randomize()
		numba = round(rng.randf_range(0, 7))
		#Dir and rotate depending
		if numba == 0:
			_velocity.x = lerp(5, 0, 0.85)
			_velocity.z = 0
			self.rotation = Vector3(0, 0 , 0)
		if numba == 1:
			_velocity.z = lerp(5, 0, 0.85)
			_velocity.x = 0
			self.rotation = Vector3(0, PI * 3/2 , 0)
		if numba == 2:
			_velocity.x = lerp(-5, 0, 0.85)
			_velocity.z = 0
			self.rotation = Vector3(0, PI , 0)
		if numba == 3:
			_velocity.z = lerp(-5, 0, 0.85)
			_velocity.x = 0
			self.rotation = Vector3(0, PI/2 , 0)
		if numba == 4:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, 0.85)
			_velocity.z = lerp((5 * sqrt(2)/2), 0, 0.85)
			self.rotation = Vector3(0, PI * 7/4 , 0)
		if numba == 5:
			_velocity.z = lerp((5 * sqrt(2)/2), 0, 0.85)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, 0.85)
			self.rotation = Vector3(0, PI * 5/4 , 0)
		if numba == 6:
			_velocity.x = lerp((5 * sqrt(2)/2), 0, 0.85)
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, 0.85)
			self.rotation = Vector3(0, PI * 1/4 , 0)
		if numba == 7:
			_velocity.z = lerp((-5 * sqrt(2)/2), 0, 0.85)
			_velocity.x = lerp((-5 * sqrt(2)/2), 0, 0.85)
			self.rotation = Vector3(0, PI * 3/4 , 0)
		
		
