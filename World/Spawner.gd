extends Node
# var dec

const HEX_OFFSET = 0.866

signal spawn_creature

var xcord
var zcord
var numba
var timer = 0
var timer_limit = 2
var color
var maxi = 5
var count = 0

var rng = RandomNumberGenerator.new()
onready var bound_x =  get_parent().chunk_x * Hex_Chunk2.CHUNK_SIZE - 1
onready var bound_z =  (get_parent().chunk_z * Hex_Chunk2.HEX_OFFSET * Hex_Chunk2.CHUNK_SIZE) - 1

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

func createCreatureAtPos(pos):
	var crt = creature.instance()
	#creature.
	
	crt.transform.origin = pos
	
	rng.randomize()
	numba = rng.randf_range(0, 10.0)
	rng.randomize()
	
	#crt.genes["speedWeight"] = rng.randf_range(0.1, 0.90)
	crt.rotation = Vector3(0, numba , 0)
	
	add_child(crt)
	count += 1

func give_birth(pos, genes1, genes2):
	var crt = creature.instance()
	var genes = [0, 1, 2]
	var clr = [0, 0, 0]
	var rnd
	var temp
	var q
	var r = 2
	for x in genes:
		randomize()
		rnd = floor(rand_range(0, 2))
		randomize()
		if rnd == 0:
			temp = genes1.values()
			q = temp[r] + rand_range(0.01, 0.2)
			if q < maxi:
				genes[x] = q
			else:
				genes[x] = maxi
		else:
			temp = genes2.values()
			q = temp[r] + rand_range(0.01, 0.2)
			if q < maxi:
				genes[x] = q
			else:
				genes[x] = maxi
		r = r+1
	clr[0] = genes[0]/5
	clr[1] = genes[1]/5
	clr[2] = genes[2]/5
	crt.genes["vis_radius"] = genes[0]
	crt.genes["speed"] = genes[1]
	crt.genes["size"] = genes[2]
	crt.get_node("mesh/Icosphere").colorChange(clr)
	crt.transform.origin = pos
	add_child(crt)
	
	
	count += 1
