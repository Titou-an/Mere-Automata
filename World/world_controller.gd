extends Spatial

const CHUNK_SIZE = 16

const hex_offset = 0.866

var water_lvl = 5
var food = preload("res://Objects/Food/food.tscn")
export var food_ammount = 50
var food_arr = []

func _input(event):
	
	if event.is_action_pressed("action_reload"):
		world_gen.clean_up()
	
	if event.is_action_pressed("action_hex_test"):
		world_gen.gen_hex_test()
		
	if event.is_action_pressed("action_hex_map"):
		world_gen.gen_hex_map()
	
	if event.is_action_pressed("action_cube_map"):
		world_gen.gen_cube_map()
	
	if event.is_action_pressed("action_reload"):
		world_gen.clean_up()
	
	if event.is_action_pressed("create_food"):
		clear_fd()
		var chunk_data = world_gen.chunk_data
		
		for x in range(food_ammount):
			var fd = food.instance()
			
			var pos = Vector3.ZERO
			
			var rand_index = randi() % chunk_data.size()
			var rand_chunk = chunk_data.values()[rand_index]
			var origin = chunk_data.keys()[rand_index] *CHUNK_SIZE
			while(true):
				
				var rand_pos = rand_chunk.keys()[randi() % rand_chunk.size()]
				
				if !food_arr.has(rand_pos):
					if rand_pos.y >= water_lvl:
						if rand_chunk[rand_pos] == 3:
							
							if rand_chunk.has(rand_pos + Vector3.UP):
								if rand_chunk[rand_pos + Vector3.UP] == 11:
									continue
							
							var odd = int(rand_pos.z)%2
							if odd:
								pos = (origin + rand_pos + Vector3(1,1,0.5)) * Vector3(1,1,hex_offset)
							else:
								pos = (origin + rand_pos + Vector3(0.5,1,0.5)) * Vector3(1,1,hex_offset)
							food_arr.append(rand_pos)
							fd.transform.origin = pos
							get_node("food").add_child(fd)
							break
				else:
					break
			
	

func clear_fd():
	for f in get_tree().get_nodes_in_group("food"):
			f.clean()
		
	for c in get_tree().get_nodes_in_group("creatures"):
		c.targ_list.clear()
		
	food_arr.clear()

