class_name TerrainGenerator
extends Resource

const CHUNK_SIZE = 16 #must be sync with chunk
const MAX_H = 8
const water_lvl = 5


static func empty():
	return {}

static func single():
	var hex_offset = round((sqrt(3)/2)*100)/100
	
	
	var data = {}
	
	
	for x in 5:
		for y in 1:
			for z in 6:
				var vec = Vector3()
				if !z % 2 == 0:
					vec = Vector3(x + 0.5,y,z * hex_offset)
				else:
					vec = Vector3(x,y,z * hex_offset)
				
				data[vec] = 3
				
	data[Vector3(0,1,0)] = 3
	print (data)
	return data

static func hill_terrain(noise, chunk_pos):
	var data = {}
	
	
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var top_h = round((noise.get_noise_2d(x + (chunk_pos.x),z + (chunk_pos.z)) + 1)/2 * MAX_H)
			var vec = Vector3(x,top_h,z)
			if top_h < water_lvl :
				data[vec] = 5
			else:
				data[vec] = 3
			
			for y in (top_h):
				vec = Vector3(x,y,z)
				data[vec] = 4
			
			for i in water_lvl:
				var water_h =Vector3(x,i,z)
				if !data.has(water_h):
					data[water_h] = 2
			
	return data

static func hex_hill_terrain(noise, chunk_pos):
	var data = {}
	var hex_offset = round((sqrt(3)/2)*100)/100
	
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var top_h = round((noise.get_noise_2d(x + (chunk_pos.x),z + (chunk_pos.z)) + 1)/2 * MAX_H)
			var vec = Vector3()
			
			if !z % 2 == 0:
				vec = Vector3(x + 0.5,top_h,z * hex_offset)
			else:
				vec = Vector3(x,top_h,z * hex_offset)
			
			if top_h < water_lvl :
				data[vec] = 5
			else:
				data[vec] = 3
			
			for y in (top_h):
				vec.y = y
				data[vec] = 4
			
			for i in water_lvl:
				vec.y = i
				if !data.has(vec):
					data[vec] = 2
			
	return data
