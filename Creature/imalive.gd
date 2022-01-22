extends KinematicBody

export var gravity := 9.8
var _velocity := Vector3()
var timer = 0
var timer_limit = 2
func _ready():
	print("sup")
	
	
	
func _process(delta):
	if not is_on_floor():
		_velocity.y -= gravity * delta
	move_and_slide(_velocity, Vector3.UP)

	timer += delta
	#Nothing to do, move in a random direction
	if (timer > timer_limit):
		
		timer -= delta
		var dir = randi() % 1
		
		#if dir == 1:
			#_velocity -= transform.basis.z
	
