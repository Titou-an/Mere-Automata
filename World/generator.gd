class_name TerrainGenerator
extends Resource

const CHUNK_SIZE = 16 #must be sync with chunk
const MAX_H = 9
const water_lvl = 5
const hex_offset = 0.866

static func empty():
	return {}

static func single():
	#var hex_offset = round((sqrt(3)/2)*1000)/1000
	
	
	var data = {}
	
	for x in 5:
		for y in 1:
			for z in 16:
				var vec = Vector3()
				
				if !z % 2 == 0:
					vec = Vector3(x + 0.5,y,z * hex_offset)
				else:
					vec = Vector3(x,y,z * hex_offset)
				
				data[vec] = 3
				
	
	data[Vector3(1,2,0)] = 3
	print (data)
	return data

static func single_cube():
	
	var data = {}
	
	for x in 14:
		for y in 1:
			for z in 16:
				var vec = Vector3(x,y,z)
				data[vec] = 3
				
	
	data[Vector3(1,2,0)] = 3
	
	#print (data)
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
				
				var rand = randf()
				if rand < 80:
					data[vec + Vector3.UP] = 10
			
			for y in (top_h):
				vec = Vector3(x,y,z)
				data[vec] = 4
			
			for i in water_lvl:
				vec.y = i
				if !data.has(vec):
					data[vec] = 2
			
	return data

static func hex_hill_terrain(noise, chunk_pos):
	var data = {}
	#var hex_offset = round((sqrt(3)/2)*1000)/1000
	
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
