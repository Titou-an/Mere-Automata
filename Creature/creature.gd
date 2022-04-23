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

var genes = {
	"species" : 0,
	"diet" : 0,
	"vis_radius" : 2.0,
	"speed" : 2,
	"size" : 1,
	"mutation" : 0.5
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

var timer = 0
var timer_limit = 1

var deg
onready var bar = $Sprite3D/Viewport/HealthBar2D

func _ready():
	scale = Vector3.ONE * genes["size"]
	
	vision.shape = SphereShape.new()
	vision.shape.radius = genes["vis_radius"]

func update_val():
	
	scale = Vector3.ONE * genes["size"]
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
	
	
	if energy < repro_treshold:
		repro_state = false
		
		if !fd_list.empty():
			
			#If there is food in the vision radius of the creature
			target = fd_list.values()[0]
			
			_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
			_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
			
		else:
			explore()
	else:
		
		repro_state = true
		if !crt_list.empty():
			var closest_crt = crt_list.keys()[0]
			
			if closest_crt.genes["species"] == genes["species"]:
				if repro_state and closest_crt.repro_state:
					target = closest_crt.global_transform.origin
					
					_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
					_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
					
				else:
					explore()
			else:
				explore()
		else:
			explore()
		
	timer += delta
	
	
	#Apply Motion
	
	_velocity = move_and_slide(_velocity, Vector3.UP)
	rotateCreature()
	
	# Energy update
	energy -= (speedWeight)/10
	energyUpdate(energy)

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
	
	mov = mov.normalized() * genes["speed"]
	_velocity.x = mov.x
	_velocity.z = mov.y
	
func rotateCreature():
#	var t = self.global_transform
#	var l = t.looking_at(target, Vector3.UP)
#	var a = Quat(t.basis)
#	var b = Quat(l.basis)
#	var c = a.slerp(b, 3 * delta)
#	self.global_transform.basis = Basis(c)
	
	rotation.y = lerp_angle(rotation.y,Vector2().angle_to_point(Vector2(_velocity.z,_velocity.x)),0.1)
	
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
			spawner.give_birth(transform.origin, body.genes, self.genes)
			crt_list.erase(body)
			
			hearts.restart()
			
			energy -= repro_cost
			energyUpdate(energy)

func stop_wait(delta):
	pass

func explore():
	# Nothing to do, move in a random direction
	
	if !((_velocity + transform.origin).x < bound_x and (_velocity + transform.origin).x > 0):
		_velocity.x = 0
	if !((_velocity + transform.origin).z < bound_z and (_velocity + transform.origin).z > 0):
		_velocity.z = 0
	
	if (timer > timer_limit):
		
		timer = 0
		rng.randomize()
		numb = round(rng.randi_range(0, 7))
		
		moveCreature(numb)
		
#	deg = (
#			270 if numb == 0
#			else 180 if numb == 1
#			else 90 if numb == 2
#			else 0 if numb == 3
#			else 225 if numb == 4
#			else 135 if numb == 5
#			else 315 if numb == 6
#			else 45
#		)
	#rotation.y = lerp_angle(rotation.y,deg2rad(deg),0.1)
	

