class_name TerrainGenerator
extends Resource

const CHUNK_SIZE = 16 #must be sync with chunk
const MAX_H = 5

static func empty():
	return {}


static func hill_terrain():
	var data = {}
	
	for x in range(CHUNK_SIZE):
		for y in range(MAX_H):
			for z in range(CHUNK_SIZE):
				var vec = Vector3(x,y,z)
				data[vec] = 3
	return data
