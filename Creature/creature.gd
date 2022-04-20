extends KinematicBody

var rng = RandomNumberGenerator.new()
export var gravity := 9.8
export var speedWeight := 0.85
export var repro_cost := 40
var repro_treshold = 70

onready var spawner = get_parent()
onready var bound_x = spawner.bound_x + 1
onready var bound_z = spawner.bound_z + 1

onready var hearts = $Hearts
onready var vision = $Vision/CollisionShape
var vision_coll = CollisionShape.new()

export var genes = {
	"species" : 0,
	"diet" : 0,
	"vis_radius" : 2.0,
	"speed" : 2
}

var fd_list = {}
var crt_list = {}
var target = Vector3()
var repro_state = false
var wait_state = false

var _velocity := Vector3()
var numb = 0
var jump = 5
var energy = 69
var speed = 0

var timer = 0
var timer_limit = 2

var deg
onready var bar = $Sprite3D/Viewport/HealthBar2D

func _ready():
	speed = genes["speed"]
	
	rng.randomize()
	genes["vis_radius"] = rng.randf_range(2,4)
	vision.shape = SphereShape.new()
	vision.shape.radius = genes["vis_radius"]

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
	
	if wait_state:
		if timer > timer_limit:
			timer = 0
			wait_state = false
	else:
		if energy > repro_treshold:
			repro_state = true
		else:
			repro_state = false
		
		if !crt_list.empty():
			var closest_crt = crt_list.keys()[0]
			
			if closest_crt.genes["species"] == genes["species"]:
				if repro_state and closest_crt.repro_state:
					target = closest_crt.global_transform.origin
					
					_velocity.x = transform.origin.direction_to(target).x * speed
					_velocity.z = transform.origin.direction_to(target).z * speed
					rotateCreature(target, delta)
	#		else:
	#			if diet != 0:
		if !fd_list.empty():
			
			#If there is food in the radius of the creature
			target = fd_list.values()[0]
			
			_velocity.x = transform.origin.direction_to(target).x * speed
			_velocity.z = transform.origin.direction_to(target).z * speed
			rotateCreature(target, delta)
			
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
	energyUpdate(energy)
	rotateCreature(target, delta)

func moveCreature(numb):
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
	
func rotateCreature(target, delta):
	
	if(fd_list.empty()):
		#rotate according to dir
		deg = (
			270 if numb == 0
			else 180 if numb == 1
			else 90 if numb == 2
			else 0 if numb == 3
			else 225 if numb == 4
			else 135 if numb == 5
			else 315 if numb == 6
			else 45
		)
		#lerp(self.rotation_degrees.y,deg,0.1)
		rotation.y = lerp_angle(rotation.y,deg2rad(deg),0.1)
#		rotation.x = lerp_angle(rotation.x, 0, 0.1)
#		rotation.z = lerp_angle(rotation.z, 0, 0.1)
	else: 
#		var t = self.global_transform
#		var l = t.looking_at(target, Vector3.UP)
#		var a = Quat(t.basis)
#		var b = Quat(l.basis)
#		var c = a.slerp(b, 3 * delta)
#		self.global_transform.basis.y = Basis(c).y
		rotation.y =  Vector2(transform.origin.x,transform.origin.z).angle_to_point(Vector2(target.x,target.z))
	
func death():
	self.queue_free()
	
	spawner.count -= 1

func energyUpdate(new_energy):
	bar.update_bar(new_energy, 100)
	
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


func _on_ReproductionArea_body_entered(body):
	if repro_state == true:
		if body.repro_state == true:
			repro_state = false
			body.repro_state = false
			wait_state = true
			body.wait_state = true
			spawner.give_birth(transform.origin, body.genes)
			crt_list.erase(body)
			
			hearts.restart()
			
			energy -= repro_cost
			energyUpdate(energy)

func stop_wait(delta):
	pass
