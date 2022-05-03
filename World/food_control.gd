extends Node

const HEX_OFFSET = 0.866
const CHUNK_SIZE = Hex_Chunk2.CHUNK_SIZE
const water_lvl = TerrainGenerator.water_lvl
var food_min = Settings.food_min
export var food_cooldown = 0.75

var data = {}
var food_arr = []
var pos_arr = []
var food = preload("res://Objects/Food/food.tscn")
var initialized = false
onready var food_timer = get_node("../FoodTimer")

onready var mutex = Mutex.new()
var pos = Vector3.ZERO
var origin = Vector3()

func _ready(): 
	food_timer.wait_time = food_cooldown
	create_pos_array()
	
func create_pos_array():
	
	for chunk in data.keys():
		for block_pos in data[chunk].keys():
			if block_pos.y >= water_lvl:
				if data[chunk][block_pos] == 3:
					
					if data[chunk].has(block_pos + Vector3.UP):
						if data[chunk][block_pos + Vector3.UP] == 11:
							continue
					var odd = int(block_pos.z)%2
					
					var temp_pos = block_pos
					origin = chunk*Hex_Chunk2.CHUNK_SIZE
					if odd:
						temp_pos = (origin + block_pos + Vector3(1,1,0.5)) * Vector3(1,1,HEX_OFFSET)
					else:
						temp_pos = (origin + block_pos + Vector3(0.5,1,0.5)) * Vector3(1,1,HEX_OFFSET)
					
					
					pos_arr.append(temp_pos)


func initialize_fd():
	
	clear_fd()
	create_pos_array()
	
	while Settings.food_count < food_min:
		add_rand_food()
	
	food_timer.start()
	initialized = true

func add_rand_food():
	while Settings.food_count <= food_min:
		randomize()
		var rand_pos = pos_arr[floor(rand_range(0,pos_arr.size()))]
		
		if !food_arr.has(rand_pos):
			
			food_arr.append(rand_pos)
			
			var fd = food.instance()
			
			fd.transform.origin = rand_pos
			fd.pos = rand_pos
			
			mutex.lock()
			Settings.food_count += 1
			mutex.unlock()
			
			add_child(fd)
			break
			
func clear_fd():
	
	initialized = false
	food_arr.clear()
	pos_arr.clear()
	
	for f in get_children():
		remove_child(f)
		f.queue_free()
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.fd_list.clear()
		
	
	Settings.food_count = 0


func _on_FoodTimer_timeout():
	add_rand_food()
