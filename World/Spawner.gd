extends Node
# var dec

const HEX_OFFSET = 0.866

var xcord
var zcord
var numba
var timer = 0
var timer_limit = 2
var color

var g_max = 5.0

var rng = RandomNumberGenerator.new()
onready var bound_x =  Settings.world_size * Hex_Chunk2.CHUNK_SIZE - 1
onready var bound_z =   (Settings.world_size * Hex_Chunk2.HEX_OFFSET * Hex_Chunk2.CHUNK_SIZE) - 1

var creature = preload("res://Creature/Creature.tscn")
	
	
func createCreatureRand(genes):
	var crt = creature.instance()
	var clr = Vector3()
	
	rng.randomize()
	xcord = rand_range(0, bound_x)
	zcord = rand_range(0, bound_z)
	crt.transform.origin = Vector3(xcord, 10, zcord)
	
	numba = rng.randf_range(0, 10.0)
	rng.randomize()
	
	#crt.genes["speedWeight"] = rng.randf_range(0.1, 0.90)
	crt.rotation.y = numba
	
	crt.genes = genes
	
	if crt.genes["species"] == Settings.Species.SPECIES1:
		crt.energy = Settings.init_energy1
	else:
		crt.energy = Settings.init_energy2
	
	clr.x = genes["speed"]/g_max
	clr.y = genes["vision"]/g_max
	clr.z = genes["size"]/g_max
	
	crt.colorChange(clr)
	
	Settings.creature_count += 1
	add_child(crt)
	

func createCreatureAtPos(pos, genes):
	var crt = creature.instance()
	var clr = Vector3()
	
	crt.transform.origin = pos
	
	rng.randomize()
	numba = rng.randf_range(0, 10.0)
	rng.randomize()
	
	#crt.genes["speedWeight"] = rng.randf_range(0.1, 0.90)
	crt.rotation.y = numba
	
	crt.genes = genes
	
	if crt.genes["species"] == Settings.Species.SPECIES1:
		crt.energy = Settings.init_energy1
	else:
		crt.energy = Settings.init_energy2
	
	clr.x = genes["speed"]/g_max
	clr.y = genes["vision"]/g_max
	clr.z = genes["size"]/g_max
	
	
	crt.colorChange(clr)
	
	Settings.creature_count += 1
	add_child(crt)
	

func give_birth(pos,genes1,genes2):
	var crt = creature.instance()

	var genes = [0,1,2]
	var clr = Vector3()
	var rnd
	var temp = []
	var q : float
	var r = 2

	var species = genes1["species"]
	var max_mut = Settings.species1_genes["mutation"] if species == Settings.Species.SPECIES1 else Settings.species2_genes["mutation"]

	for x in genes:
		randomize()
		rnd = floor(rand_range(0, 2))
		
		randomize()
		if rnd == 0:
			temp = genes1.values()
			q = temp[r] + rand_range(-1*max_mut, max_mut)
			print(temp)
			print(genes1)
			if q < g_max:
				genes[x] = q
			else:
				genes[x] = g_max
		else:
			temp = genes2.values()
			q = temp[r] + rand_range(-1*max_mut, max_mut)
			print(temp)
			print(genes2)
			if q < g_max:
				genes[x] = q
			else:
				genes[x] = g_max
		r += 1
	
	clr.x = genes[0]/g_max
	clr.y = genes[1]/g_max
	clr.z = genes[2]/g_max
	
	crt.genes["species"] = species
	crt.genes["vision"] = genes[0]
	crt.genes["speed"] = genes[1]
	crt.genes["size"] = genes[2]
	crt.genes["diet"] = genes1["diet"]
	crt.genes["mutation"] = genes1["mutation"]
	crt.colorChange(clr)

	if crt.genes["species"] == Settings.Species.SPECIES1:
		crt.energy = Settings.init_energy1
	else:
		crt.energy = Settings.init_energy2
	
	crt.transform.origin = pos
	
	Settings.creature_count += 1
	add_child(crt)
	
	
