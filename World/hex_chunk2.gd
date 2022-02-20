class_name Hex_Chunk2
extends StaticBody

const CHUNK_SIZE = 16 #must be sync with generator
const TEXTURE_TILE_WIDTH = 8

const TEXTURE_TILE_SIZE = 1.0 / TEXTURE_TILE_WIDTH

var data = {}
var chunk_pos = Vector3()

var poly_count = 0

const hex_offset = 0.866

var thread
var thread2

var block_mesh 
onready var world_builder = get_parent()

func _init(c_data):
	data = c_data

func _reload_chunks():
	
	for c in get_children():
		remove_child(c)
		c.queue_free()
	
	_generate_collider()
	_generate_mesh()

func _ready():
	transform.origin = chunk_pos * CHUNK_SIZE * Vector3(1,1,hex_offset)
	name = str(chunk_pos * Vector3(1,1,hex_offset))
	
	_generate_collider()
	
	thread = Thread.new()
	thread2 = Thread.new()
	
	thread.start(self, "_generate_mesh")
	thread2.start(self, "_generate_water")
	

func _generate_collider():
	if data.empty():
		_create_mesh_collider(Vector3.ZERO)
		collision_layer = 0
		collision_mask = 0
		return
	
	collision_layer = 0xFFFFF
	collision_mask = 0xFFFFF
	for block_pos in data.keys():
		var block_id = data[block_pos]
		_create_mesh_collider(block_pos)

func _generate_mesh():
	
	if data.empty():
		print("The chunk has no data")
		return
	
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for block_pos in data.keys():
		var block_id = data[block_pos]
		if block_id == 2:
			continue
		_draw_mesh(surface_tool, block_pos, block_id, false)
	
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	surface_tool.index()
	var array_mesh = surface_tool.commit()
	var mi = MeshInstance.new()
	mi.mesh = array_mesh
	
	mi.material_override = preload("res://World/Textures/material.tres")
	add_child(mi)
	
	
	

func _generate_water():
	
	if data.empty():
		print("The chunk has no data")
		return
	
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for block_pos in data.keys(): #Changed from data.keys
		var top_water = false
		
		var block_id = data[block_pos]
		if block_id != 2:
			continue
		
		var other_pos = block_pos + Vector3.UP
		var other_id = 0
		
		if other_pos.y == CHUNK_SIZE:
			other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
		elif data.has(other_pos):
			other_id = data[other_pos]
			print(other_id)
		if other_id !=2:
			top_water = true
		
		_draw_mesh(surface_tool, block_pos, block_id, top_water)
	
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	surface_tool.index()
	var array_mesh = surface_tool.commit()
	var mi = MeshInstance.new()
	mi.mesh = array_mesh
	
	mi.material_override = preload("res://World/Textures/watertest.tres")
	add_child(mi)

func _draw_mesh(surface_tool, block_pos, block_id,top_water):
	
	var verts = {}
	var odd = int(block_pos.z)%2
	if  odd:
		verts = calculate_verts((block_pos + (Vector3.RIGHT/2)) * Vector3(1,1,hex_offset), top_water)
	else:
		verts = calculate_verts(block_pos * Vector3(1,1,hex_offset), top_water)
	
	var uvs = calculate_uvs(block_id)
	var top_uvs = calculate_hex_uvs(block_id)
	var bottom_uvs = calculate_hex_uvs(block_id)
	
	
	
	if block_id == 3: # Grass.
		top_uvs = calculate_hex_uvs(0)
		bottom_uvs = calculate_hex_uvs(2)
	
	
	var other_pos = block_pos + Vector3.LEFT
	var other_id = 0
	if other_pos.x == -1:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[3], verts[1], verts[6], verts[4]], uvs)
	
	other_pos = block_pos + Vector3.RIGHT
	other_id = 0
	if other_pos.x == CHUNK_SIZE:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[10], verts[8], verts[11], verts[9]], uvs)
	
	
	# Front Left
	if odd:
		other_pos = block_pos + Vector3.FORWARD 
	else:
		other_pos = block_pos + Vector3.FORWARD + Vector3.LEFT
	
	other_id = 0
	
	if other_pos.z == -1 or other_pos.x == -1:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[2], verts[0], verts[3], verts[1]], uvs)
	
	# Front Right
	if odd:
		other_pos = block_pos + Vector3.FORWARD + Vector3.RIGHT
	else:
		other_pos = block_pos + Vector3.FORWARD 
	
	other_id = 0
	if other_pos.z == -1 or other_pos.x == CHUNK_SIZE:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	if data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[11], verts[9], verts[2], verts[0]], uvs)
	
	# Back Left
	if odd:
		other_pos = block_pos + Vector3.BACK 
	else:
		other_pos = block_pos + Vector3.BACK + Vector3.LEFT
	
	
	other_id = 0
	if other_pos.z == CHUNK_SIZE or other_pos.x == -1:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	if data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[6], verts[4], verts[7], verts[5]], uvs)
	
	# Back Right
	if odd:
		other_pos = block_pos + Vector3.BACK + Vector3.RIGHT
	else:
		other_pos = block_pos + Vector3.BACK 
	
	other_id = 0
	if other_pos.z == CHUNK_SIZE or other_pos.x == CHUNK_SIZE:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[7], verts[5], verts[10], verts[8]], uvs)
	
	
	other_pos = block_pos + Vector3.UP
	other_id = 0
	if other_pos.y == CHUNK_SIZE:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_hex_face(surface_tool, [verts[6], verts[7], verts[10], verts[11],verts[2],verts[3],verts[13]], top_uvs)
	
	other_pos = block_pos + Vector3.DOWN
	other_id = 0
	if other_pos.y == -1:
		other_id = world_builder.get_global_position_id(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_hex_face(surface_tool, [verts[8], verts[5], verts[4], verts[1],verts[0],verts[9],verts[12]], bottom_uvs)
	

func _draw_face(surface_tool, verts, uvs):
	poly_count += 2
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[3]); surface_tool.add_vertex(verts[3])

	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[0]); surface_tool.add_vertex(verts[0])
	

func _draw_hex_face(surface_tool, verts, uvs):
	poly_count += 6
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])

	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[3]); surface_tool.add_vertex(verts[3])
	
	surface_tool.add_uv(uvs[3]); surface_tool.add_vertex(verts[3])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[4]); surface_tool.add_vertex(verts[4])
	
	surface_tool.add_uv(uvs[4]); surface_tool.add_vertex(verts[4])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[5]); surface_tool.add_vertex(verts[5])
	
	surface_tool.add_uv(uvs[5]); surface_tool.add_vertex(verts[5])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[0]); surface_tool.add_vertex(verts[0])
	
	surface_tool.add_uv(uvs[0]); surface_tool.add_vertex(verts[0])
	surface_tool.add_uv(uvs[6]); surface_tool.add_vertex(verts[6])
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	
func _create_mesh_collider(block_pos):
	
	var collider = CollisionShape.new()
	collider.shape = BoxShape.new()
	collider.shape.extents = Vector3.ONE / 2
	
	if !int(block_pos.z)%2 == 0:
		
		collider.transform.origin = (block_pos * Vector3(1,1,hex_offset))  + Vector3(1,0.5,0.5)
	else:
		collider.transform.origin = (block_pos * Vector3(1,1,hex_offset)) + Vector3.ONE / 2
	
	add_child(collider)

static func calculate_verts(block_pos, top_water):
	
	var hex_side = (sqrt(3)/3)
	var hex_sqr = hex_side/2
	
	if top_water:
		return[
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z),
			Vector3(block_pos.x, block_pos.y, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 0.5, block_pos.y + 0.9, block_pos.z),
			Vector3(block_pos.x, block_pos.y + 0.9, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x, block_pos.y, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z + 2 * hex_side),
			
			Vector3(block_pos.x, block_pos.y + 0.9, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 0.5, block_pos.y + 0.9, block_pos.z + 2 * hex_side),
			
			Vector3(block_pos.x + 1, block_pos.y, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 1, block_pos.y, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 1, block_pos.y + 0.9, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 1, block_pos.y + 0.9, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z + 0.5),
			Vector3(block_pos.x + 0.5, block_pos.y + 0.9, block_pos.z + 0.5)
		]
	else:
		return[
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z),
			Vector3(block_pos.x, block_pos.y, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 0.5, block_pos.y + 1, block_pos.z),
			Vector3(block_pos.x, block_pos.y + 1, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x, block_pos.y, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z + 2 * hex_side),
			
			Vector3(block_pos.x, block_pos.y + 1, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 0.5, block_pos.y + 1, block_pos.z + 2 * hex_side),
			
			Vector3(block_pos.x + 1, block_pos.y, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 1, block_pos.y, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 1, block_pos.y + 1, block_pos.z + hex_sqr + hex_side),
			Vector3(block_pos.x + 1, block_pos.y + 1, block_pos.z + hex_sqr),
			
			Vector3(block_pos.x + 0.5, block_pos.y, block_pos.z + 0.5),
			Vector3(block_pos.x + 0.5, block_pos.y + 1, block_pos.z + 0.5)
		]

static func calculate_uvs(block_id):
	
	var row = block_id / TEXTURE_TILE_WIDTH
	var col = block_id % TEXTURE_TILE_WIDTH
	
	return[
		TEXTURE_TILE_SIZE * Vector2(col, row),
		TEXTURE_TILE_SIZE * Vector2(col, row + 1),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row + 1),
	]

static func calculate_hex_uvs(block_id):
	
	var hex_sqr = 0.25
	var hex_side = 0.5
	
	var row = block_id / TEXTURE_TILE_WIDTH
	var col = block_id % TEXTURE_TILE_WIDTH
	
	return[
		TEXTURE_TILE_SIZE * Vector2(col, row + hex_sqr),
		TEXTURE_TILE_SIZE * Vector2(col + 0.5, row),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row + hex_sqr),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row + hex_sqr + hex_side),
		TEXTURE_TILE_SIZE * Vector2(col + 0.5, row + 1),
		TEXTURE_TILE_SIZE * Vector2(col, row + hex_sqr + hex_side),
		TEXTURE_TILE_SIZE * Vector2(col+0.5, row + sqrt(3)/3),
	]

static func is_transparent(block_id):
	return block_id == 0 or block_id == 2 or block_id == 6

func get_poly():
	return poly_count
