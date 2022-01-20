extends Node

const CHUNK_MIDPOINT = Vector3(0.5, 0.5, 0.5) * Chunk.CHUNK_SIZE
const CHUNK_END_SIZE = Chunk.CHUNK_SIZE - 1

var _chunks = {}

func _ready():
	
	var chunk = Chunk.new()
	chunk.chunk_pos = Vector3.ZERO
	_chunks[Vector3.ZERO] = chunk
	add_child(chunk)


func clean_up():
	for chunk_position_key in _chunks.keys():
		var thread = _chunks[chunk_position_key]._thread
		if thread:
			thread.wait_to_finish()
	_chunks = {}
	set_process(false)
	for c in get_children():
		c.free()

func get_global_position(block_global_position):
	var chunk_position = (block_global_position / Chunk.CHUNK_SIZE).floor()
	if _chunks.has(chunk_position):
		var chunk = _chunks[chunk_position]
		var sub_position = block_global_position.posmod(Chunk.CHUNK_SIZE)
		if chunk.data.has(sub_position):
			return chunk.data[sub_position]
	return 0
