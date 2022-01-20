class_name TerrainGenerator
extends Resource

const CHUNK_SIZE = 16 #must be sync with chunk
const MAX_H = 6



static func empty():
	return {}


static func hill_terrain(noise, chunk_pos):
	var data = {}
	var water_lvl = 3
	
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var top_h = round((noise.get_noise_2d(x + (chunk_pos.x),z + (chunk_pos.z)) + 1.0)/2 * MAX_H)
			var vec = Vector3(x,top_h,z)
			data[vec] = 3
			
			for y in (top_h):
				vec = Vector3(x,y,z)
				data[vec] = 3
			print(top_h)
			
			var water_h =Vector3(x,water_lvl,z)
			if !data.has(water_h):
				data[water_h] = 2
			
	return data
