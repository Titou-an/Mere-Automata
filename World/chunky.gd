class_name Cube_Chunk
extends StaticBody

const CHUNK_SIZE = 16 #must be sync with generator
const TEXTURE_TILE_WIDTH = 8

const TEXTURE_TILE_SIZE = 1.0 / TEXTURE_TILE_WIDTH

var data = {}
var chunk_pos = Vector3()

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
	transform.origin = chunk_pos * CHUNK_SIZE
	name = str(chunk_pos)
	
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
		_draw_mesh(surface_tool, block_pos, block_id)
	
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
	
	for block_pos in data.keys():
		var block_id = data[block_pos]
		if block_id != 2:
			continue
		_draw_mesh(surface_tool, block_pos, block_id)
	
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	surface_tool.index()
	var array_mesh = surface_tool.commit()
	var mi = MeshInstance.new()
	mi.mesh = array_mesh
	
	mi.material_override = preload("res://World/Textures/water.tres")
	add_child(mi)

func _draw_mesh(surface_tool, block_pos, block_id):
	var verts = calculate_verts(block_pos)
	var uvs = calculate_uvs(block_id)
	var top_uvs = uvs
	var bottom_uvs = uvs
	
	if block_id == 3: # Grass.
		top_uvs = calculate_uvs(0)
		bottom_uvs = calculate_uvs(2)
	
	var other_pos = block_pos + Vector3.LEFT
	var other_id = 0
	if other_pos.x == -1:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[2], verts[0], verts[3], verts[1]], uvs)
	
	other_pos = block_pos + Vector3.RIGHT
	other_id = 0
	if other_pos.x == CHUNK_SIZE:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[7], verts[5], verts[6], verts[4]], uvs)
	
	other_pos = block_pos + Vector3.FORWARD
	other_id = 0
	if other_pos.z == -1:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[6], verts[4], verts[2], verts[0]], uvs)
	
	other_pos = block_pos + Vector3.BACK
	other_id = 0
	if other_pos.z == CHUNK_SIZE:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[3], verts[1], verts[7], verts[5]], uvs)
	
	other_pos = block_pos + Vector3.UP
	other_id = 0
	if other_pos.y == CHUNK_SIZE:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[2], verts[3], verts[6], verts[7]], top_uvs)
	
	other_pos = block_pos + Vector3.DOWN
	other_id = 0
	if other_pos.y == -1:
		other_id = world_builder.get_global_position(other_pos + chunk_pos * CHUNK_SIZE)
	elif data.has(other_pos):
		other_id = data[other_pos]
	if block_id != other_id and is_transparent(other_id):
		_draw_face(surface_tool, [verts[4], verts[5], verts[0], verts[1]], bottom_uvs)
	

func _draw_face(surface_tool, verts, uvs):
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[3]); surface_tool.add_vertex(verts[3])

	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[0]); surface_tool.add_vertex(verts[0])

func _create_mesh_collider(block_pos):
	var collider = CollisionShape.new()
	collider.shape = BoxShape.new()
	collider.shape.extents = Vector3.ONE / 2
	collider.transform.origin = block_pos + Vector3.ONE / 2
	add_child(collider)

static func calculate_verts(block_pos):
	return[
		Vector3(block_pos.x, block_pos.y, block_pos.z),
		Vector3(block_pos.x, block_pos.y, block_pos.z + 1),
		Vector3(block_pos.x, block_pos.y + 1, block_pos.z),
		Vector3(block_pos.x, block_pos.y + 1, block_pos.z + 1),
		Vector3(block_pos.x + 1, block_pos.y, block_pos.z),
		Vector3(block_pos.x + 1, block_pos.y, block_pos.z + 1),
		Vector3(block_pos.x + 1, block_pos.y + 1, block_pos.z),
		Vector3(block_pos.x + 1, block_pos.y + 1, block_pos.z + 1),
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

static func is_transparent(block_id):
	return block_id == 0 or block_id == 2
