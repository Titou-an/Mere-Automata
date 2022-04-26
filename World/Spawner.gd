extends Node
# var dec

const HEX_OFFSET = 0.866

var xcord
var zcord
var numba
var timer = 0
var timer_limit = 2.0
var color

var g_max = 5.0
var g_min = 0.1

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
	
	crt.genes = genes.duplicate()
	
	if crt.genes["species"] == Settings.Species.SPECIES1:
		Settings.species1_count += 1
		crt.energy = Settings.init_energy1
	else:
		Settings.species2_count += 1
		crt.energy = Settings.init_energy2
	
	clr.x = crt.genes["vision"]/g_max
	clr.y = crt.genes["speed"]/g_max
	clr.z = crt.genes["size"]/g_max
	
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
	
	crt.genes = genes.duplicate()
	
	if crt.genes["species"] == Settings.Species.SPECIES1:
		Settings.species1_count += 1
		crt.energy = Settings.init_energy1
	else:
		Settings.species2_count += 1
		crt.energy = Settings.init_energy2
	
	clr.x = crt.genes["vision"]/g_max
	clr.y = crt.genes["speed"]/g_max
	clr.z = crt.genes["size"]/g_max
	
	
	crt.colorChange(clr)
	
	Settings.creature_count += 1
	add_child(crt)
	

func give_birth(pos : Vector3, genes1 : Dictionary, genes2 : Dictionary):
	
	var genes = genes1.duplicate()
	var clr = Vector3()
	var rand
	
	var max_mut = Settings.species1_genes["mutation"] if genes["species"] == Settings.Species.SPECIES1 else Settings.species2_genes["mutation"]
	
	for g in Settings.species1_enabled_genes.keys():
		
		randomize()
		rand = randi() % 2
		
		randomize()
		
		if rand == 0:
			
			if genes["species"] == Settings.Species.SPECIES1:
				if !Settings.species1_enabled_genes[g]:
					genes[g] = genes1[g]
					continue
			else:
				if !Settings.species2_enabled_genes[g]:
					genes[g] = genes1[g]
					continue
			
			genes[g] = genes1[g] + rand_range(-1.0*max_mut, max_mut)
			if genes[g] > g_max:
				genes[g] = g_max
			elif genes[g] < g_min:
				genes[g] = g_min
			
		else:
				
			if genes["species"] == Settings.Species.SPECIES1:
				if !Settings.species1_enabled_genes[g]:
					genes[g] = genes2[g]
					continue
			else:
				if !Settings.species2_enabled_genes[g]:
					genes[g] = genes2[g]
					continue
			
			genes[g] = genes2[g] + rand_range(-1.0* max_mut, max_mut)
			if genes[g] > g_max:
				genes[g] = g_max
			elif genes[g] < g_min:
				genes[g] = g_min
	
	clr.x = genes["vision"]/(g_max *1.5)
	clr.y = genes["speed"]/g_max
	clr.z = genes["size"]/g_max
	
	var crt = creature.instance()
	crt.genes = genes
	
	if crt.genes["species"] == Settings.Species.SPECIES1:
		Settings.species1_count += 1
		crt.energy = (Settings.init_energy1 / (Settings.species1_genes["size"] * 100)) * (genes["size"] * 100)
	else:
		Settings.species2_count += 1
		crt.energy =  (Settings.init_energy2 / (Settings.species2_genes["size"] * 100)) * (genes["size"] * 100)
	
	
	crt.colorChange(clr)
	crt.transform.origin = pos
	
	Settings.creature_count += 1
	add_child(crt)
	
	
