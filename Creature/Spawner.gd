extends Node
# var dec

const hex_offset = 0.866

var xcord
var zcord
var numba
var timer = 0
var timer_limit = 2
var color
var count = 0
var rng = RandomNumberGenerator.new()
var bound_x = WorldGen.chunk_x * Hex_Chunk2.CHUNK_SIZE - 1
var bound_z = (WorldGen.chunk_z * Hex_Chunk2.hex_offset * Hex_Chunk2.CHUNK_SIZE) - 1

var creature = preload("res://Creature/Creature.tscn")
	
	
func _physics_process(delta):
#	timer += delta

	if Input.is_action_just_pressed("ui_up"):
		createCreature()
	
#	if (timer > timer_limit):
#		timer = 0
#		createCreature()

func createCreature():
	var crt = creature.instance()
	#creature.
	
	xcord = rand_range(0, bound_x)
	zcord = rand_range(0, bound_z)
	crt.transform.origin = Vector3(xcord, 10, zcord)
	
	rng.randomize()
	numba = rng.randf_range(0, 10.0)
	rng.randomize()
	crt.speedWeight = rng.randf_range(0.1, 0.90)
	crt.rotation = Vector3(0, numba , 0)
	
	add_child(crt)
	count += 1
