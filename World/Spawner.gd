class_name Spawner
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
onready var bound_x =  get_parent().chunk_x * Hex_Chunk2.CHUNK_SIZE - 1
onready var bound_z =  (get_parent().chunk_z * Hex_Chunk2.hex_offset * Hex_Chunk2.CHUNK_SIZE) - 1

var creature = preload("res://Creature/Creature.tscn")


func createCreature():
	var crt = creature.instance()
	#creature.
	
	xcord = rand_range(0, bound_x)
	zcord = rand_range(0, bound_z)
	crt.transform.origin = Vector3(xcord, 10, zcord)
	
	rng.randomize()
	numba = rng.randf_range(0, 10.0)
	rng.randomize()
	
	crt.genes["speedWeight"] = rng.randf_range(0.1, 0.90)
	crt.rotation = Vector3(0, numba , 0)
	
	add_child(crt)
	count += 1

func give_birth(pos,genesA, genesB):
	var crt = creature.instance()
	
	crt.transform.origin = pos
	add_child(crt)
	
	count += 1
