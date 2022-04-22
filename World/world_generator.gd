extends Node

#const CHUNK_MIDPOINT = Vector3(0.5, 0.5, 0.5) * Cube_Chunk.CHUNK_SIZE
#const CHUNK_END_SIZE = Cube_Chunk.CHUNK_SIZE - 1

var chunk_data = {}
var _chunks = {}

var thread = null

var noise = OpenSimplexNoise.new()

onready var world_seed = get_parent().world_seed

onready var chunk_x = get_parent().chunk_x
onready var chunk_y = get_parent().chunk_y
onready var chunk_z = get_parent().chunk_z

var grass_mm
var tree_mm

const GRASS_MESH = preload("res://Objects/Grass/grass.obj")
const TREE_MESH = preload("res://Objects/Tree/tree_oak.mesh")

const GRASS_MATERIAL = preload("res://Objects/Grass/grass.material")

var progress = 0


func _ready():
	noise.seed = world_seed
	noise.octaves = 3
	noise.period = 15
	noise.persistence = 0.2
	
	
	for x in range(chunk_x):
		for z in range(chunk_z):
			for y in range(chunk_y):
				var chunk_pos = Vector3(x,y,z)
				var data = TerrainGenerator.hill_terrain(noise,chunk_pos * Hex_Chunk2.CHUNK_SIZE)
				chunk_data[chunk_pos] = data
	

func clean_up():
	
	for chunk_position_key in _chunks.keys():
		var thread = _chunks[chunk_position_key].thread
		if thread:
			thread.wait_to_finish()
	_chunks = {}

	#set_process(false)
	for c in get_children():
		c.free()
	
func get_global_position_id(block_global_position):
	var chunk_position = (block_global_position / Hex_Chunk2.CHUNK_SIZE).floor()
	
	if chunk_data.has(chunk_position):
		var c_data = chunk_data[chunk_position]
		var sub_position = block_global_position.posmod(Hex_Chunk2.CHUNK_SIZE)
		if c_data.has(sub_position):
			return c_data[sub_position]
	return 0

func get_noise():
	return noise

#func gen_hex_test():
#	clean_up()
#
#	var chunk = Hex_Chunk2.new(TerrainGenerator.single_cube())
#	chunk.chunk_pos = Vector3.ZERO
#	_chunks[Vector3.ZERO] = chunk
#	add_child(chunk)

func gen_hex_map():
	# Method for generating an hexagonal world
	clean_up()
	
	progress = 0
	
	grass_mm = MultiMesh.new()
	grass_mm.transform_format = MultiMesh.TRANSFORM_3D
	grass_mm.mesh = GRASS_MESH
	grass_mm.instance_count = 1000
	grass_mm.visible_instance_count = 0
	
	tree_mm = MultiMesh.new()
	tree_mm.transform_format = MultiMesh.TRANSFORM_3D
	tree_mm.mesh = TREE_MESH
	tree_mm.instance_count = 200
	tree_mm.visible_instance_count = 0
	
	for chunk_pos in chunk_data:
		var chunk = Hex_Chunk2.new(chunk_data[chunk_pos], tree_mm, grass_mm)
		chunk.chunk_pos = chunk_pos
		_chunks[chunk_pos] = chunk
		add_child(chunk)
		chunk.owner = get_node("/root/Main/World")
#		thread = Thread.new()
#		thread.start(self, "load_chunk", i)
		
		
	
	var grass_mm_instance = MultiMeshInstance.new()
	grass_mm_instance.multimesh = grass_mm
	grass_mm_instance.material_override = GRASS_MATERIAL
	add_child(grass_mm_instance)
	grass_mm_instance.owner = get_node("/root/Main/World")
	
	var tree_mm_instance = MultiMeshInstance.new()
	tree_mm_instance.multimesh = tree_mm
	add_child(tree_mm_instance)
	tree_mm_instance.owner =  get_node("/root/Main/World")
	

func load_chunk(chunk_pos):
	var chunk = Hex_Chunk2.new(chunk_data[chunk_pos], tree_mm, grass_mm)
	chunk.chunk_pos = chunk_pos
	_chunks[chunk_pos] = chunk
	add_child(chunk)
	chunk.owner = get_node("/root/Main/World")
	#progress = chunk_pos/chunk_data.size()
	#print(progress)

func gen_cube_map():
	clean_up()
	
	
	for i in chunk_data:
		var chunk = Cube_Chunk.new(chunk_data[i])
		chunk.chunk_pos = i
		_chunks[i] = chunk
		add_child(chunk)

func _exit_tree():
	for chunk_position_key in _chunks.keys():
		var thread = _chunks[chunk_position_key].thread
		if thread:
			thread.wait_to_finish()
