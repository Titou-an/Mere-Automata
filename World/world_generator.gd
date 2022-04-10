extends Node
#const CHUNK_MIDPOINT = Vector3(0.5, 0.5, 0.5) * Cube_Chunk.CHUNK_SIZE
#const CHUNK_END_SIZE = Cube_Chunk.CHUNK_SIZE - 1

#var hex_offset = round((sqrt(3)/2)*1000)/1000
const hex_offset = 0.866
var chunk_data = {}
var _chunks = {}

var thread = null

var noise = OpenSimplexNoise.new()
export var world_seed = 1

var chunk_x = 2
var chunk_y = 1
var chunk_z = 2


var progress = 0
#onready var prog_bar = get_node("CanvasLayer/ProgressBar")



func _ready():
	noise.seed = world_seed
	noise.octaves = 3
	noise.period = 15
	noise.persistence = 0.2
	
	
	for x in range(chunk_x):
		for z in range(chunk_z):
			for y in range(chunk_y):
				var chunk_pos = Vector3(x,y,z)
				var data = TerrainGenerator.hill_terrain(noise,chunk_pos * Cube_Chunk.CHUNK_SIZE)
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
	var chunk_position = (block_global_position / Cube_Chunk.CHUNK_SIZE).floor()
	
	if chunk_data.has(chunk_position):
		var c_data = chunk_data[chunk_position]
		var sub_position = block_global_position.posmod(Cube_Chunk.CHUNK_SIZE)
		if c_data.has(sub_position):
			return c_data[sub_position]
	return 0

func get_noise():
	return noise

func gen_hex_test():
	clean_up()
	
	var chunk = Hex_Chunk2.new(TerrainGenerator.single_cube())
	chunk.chunk_pos = Vector3.ZERO
	_chunks[Vector3.ZERO] = chunk
	add_child(chunk)

func gen_hex_map():
	clean_up()
	
	progress = 0
	for chunk_pos in chunk_data:
		var chunk = Hex_Chunk2.new(chunk_data[chunk_pos])
		chunk.chunk_pos = chunk_pos
		_chunks[chunk_pos] = chunk
		add_child(chunk)
#		thread = Thread.new()
#		thread.start(self, "load_chunk", i)
		
		
	
func load_chunk(chunk_pos):
	var chunk = Hex_Chunk2.new(chunk_data[chunk_pos])
	chunk.chunk_pos = chunk_pos
	_chunks[chunk_pos] = chunk
	add_child(chunk)
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
