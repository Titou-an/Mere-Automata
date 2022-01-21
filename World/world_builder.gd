extends Node

#const CHUNK_MIDPOINT = Vector3(0.5, 0.5, 0.5) * Cube_Chunk.CHUNK_SIZE
#const CHUNK_END_SIZE = Cube_Chunk.CHUNK_SIZE - 1


var chunk_data = {}
var _chunks = {}

var noise = OpenSimplexNoise.new()
export var world_seed = 1.0

var chunk_x = 3
var chunk_y = 1
var chunk_z = 3

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
	
	
	for y in range(chunk_y):
		for x in range(chunk_x):
			for z in range(chunk_z):
				var chunk_pos = Vector3(x,y,z)
				var chunk = Cube_Chunk.new(chunk_data[chunk_pos])
				chunk.chunk_pos = chunk_pos
				_chunks[chunk_pos] = chunk
				add_child(chunk)

func clean_up():
	for chunk_position_key in _chunks.keys():
		var thread = _chunks[chunk_position_key].thread
		var thread2 = _chunks[chunk_position_key].thread2
		if thread:
			thread.wait_to_finish()
			thread2.wait_to_finish()
	_chunks = {}
	set_process(false)
	for c in get_children():
		c.free()

func get_global_position(block_global_position):
	var chunk_position = (block_global_position / Cube_Chunk.CHUNK_SIZE).floor()
	if chunk_data.has(chunk_position):
		var c_data = chunk_data[chunk_position]
		var sub_position = block_global_position.posmod(Cube_Chunk.CHUNK_SIZE)
		if c_data.has(sub_position):
			return c_data[sub_position]
	return 0

func get_noise():
	return noise

func _input(event):
	if event.is_action_pressed("action_reload"):
		clean_up()
