extends KinematicBody

var rng = RandomNumberGenerator.new()
export var gravity := 9.8

export var move_cost := 0.6

export var repro_cost := 40
export var repro_treshold = 0.70
var max_energy = 100

onready var spawner = get_parent()
onready var bound_x = spawner.bound_x + 1
onready var bound_z = spawner.bound_z + 1

onready var hearts = $Hearts
onready var vision = $Vision/CollisionShape
var vision_coll = CollisionShape.new()

var genes = {}

var fd_list = {}
var crt_list = {}

var target = Vector3()
var repro_state = false

var _velocity := Vector3()
var numb = 0
var jump = 5
var energy = 69

var timer = 0
var timer_limit = 1.5

var deg
onready var bar = $mesh/Sprite3D

func _ready():
	$mesh.scale = (Vector3.ONE * genes["size"])/2
	$CollisionShape.shape.height = genes["size"]
	max_energy = genes["size"] * 100
	
	
	vision.shape = SphereShape.new()
	vision.shape.radius = genes["vision"]

func update_val():
	
	$mesh.scale = (Vector3.ONE * genes["size"])/2
	$CollisionShape.shape.height = genes["size"]
	max_energy = genes["size"] * 100
	
	vision.shape.radius = genes["vision"]
	

func _physics_process(delta):
	
	# Decision Tree Based on Priority 
	
	# Dying from lack of energy
	if energy <= 0:
		death()
	
	# Dying from falling out of bound
	if self.transform.origin.y < 0:
		death()
	
	# Applies gravity
	_velocity.y -= gravity * delta
	
	# Jumps in front of an obstacle
	if is_on_wall():
		
		_velocity.y = jump
		moveCreature(numb)
		timer = 0
	
	# If the the energy level is below the minimum to reproduce
	if energy < (repro_treshold * max_energy):
		repro_state = false
		
		#If there is food in the vision radius of the creature
		if genes["diet"] == Settings.Diets.HERBIVORE: # If creature is herbivore
			if !fd_list.empty():
				target = fd_list.values()[0]
				
				_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
				_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
				
			else:
				# Random Exploration to find food
				explore()
			
		elif genes["diet"] == Settings.Diets.CARNIVORE:# If Creature is carnivore
			if !crt_list.empty():
				var closest_crt = crt_list.keys()[0]
				if closest_crt.genes["species"] != genes["species"]:
					target = closest_crt.global_transform.origin
					
					_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
					_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
				else:
					explore()
			else:
				explore()
				
		else: # If creature is omnivore
			if !fd_list.empty():
				target = fd_list.values()[0]
				
				_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
				_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
				
			elif !crt_list.empty():
				var closest_crt = crt_list.keys()[0]
				if closest_crt.genes["species"] != genes["species"]:
					target = closest_crt.global_transform.origin
					
					_velocity.x = transform.origin.direction_to(target).x * genes["speed"]
					_velocity.z = transform.origin.direction_to(target).z * genes["speed"]
				else:
					explore()
			else:
				# Random Exploration to find food
				explore()
	else:
		repro_state = true
		
		if !crt_list.empty():
			var closest_crt = crt_list.keys()[0]
			
			if closest_crt.genes["species"] == genes["species"]:
				if closest_crt.repro_state:
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
	energy -= (move_cost * genes["speed"])/10 * Engine.time_scale
	energyUpdate(energy)

func moveCreature(dir):
	var mov = (
		Vector2(1,0) if dir == 0 
		else Vector2(0,1) if dir == 1
		else Vector2(-1,0) if dir == 2
		else Vector2(0,-1) if dir == 3
		else Vector2(1,1) if dir == 4
		else Vector2(-1,1) if dir == 5
		else Vector2(1,-1) if dir == 6
		else Vector2(-1,-1) 
	)
	
	mov = mov.normalized() * genes["speed"]
	_velocity.x = mov.x
	_velocity.z = mov.y
	
func rotateCreature():
	rotation.y = lerp_angle(rotation.y,Vector2().angle_to_point(Vector2(_velocity.z,_velocity.x)),0.1)
	
func death():
	Settings.creature_count -= 1
	self.queue_free()
	

func energyUpdate(new_energy):
	bar.update(new_energy, max_energy)
	
func get_energy():
	return energy

func set_energy(new_energy):
	self.energy = new_energy

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
	
	if body.genes["species"] == genes["species"]:
		if repro_state == true:
			if body.repro_state == true:
				repro_state = false
				body.repro_state = false
				
				energy -= repro_cost
				energyUpdate(energy)
				
				spawner.give_birth(transform.origin, genes, body.genes)
				crt_list.erase(body)
				
				hearts.restart()
				
				
	else:
		if genes["diet"] != Settings.Diets.HERBIVORE:
			body.death()
			energy += Settings.food_regen
			energyUpdate(energy)

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
	
func colorChange(color: Vector3):
   
	var newmat = SpatialMaterial.new()
	newmat.albedo_color = Color(color.x, color.y, color.z)
	$mesh/Icosphere.material_override = newmat

func update_color():
	$mesh/Icosphere.material_override.albedo_color = Color(genes["vision"]/5.0, genes["speed"]/5.0, genes["size"]/5.0)
