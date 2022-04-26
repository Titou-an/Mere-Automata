extends Node

const HEX_OFFSET = 0.866
const CHUNK_SIZE = Hex_Chunk2.CHUNK_SIZE
const water_lvl = TerrainGenerator.water_lvl
var food_max = Settings.food_max
export var food_cooldown = 1

var data = {}
var food_arr = []
var food = preload("res://Objects/Food/food.tscn")
var initialized = false
onready var food_timer = Timer.new()

var pos = Vector3.ZERO
var rand_index = 0
var rand_chunk = {}
var origin = Vector3()
var rand_pos = Vector3()


func _ready():
	food_timer.wait_time = food_cooldown
	food_timer.connect("timeout",self,"add_rand_food")
	

func _physics_process(_delta):
	
	if Settings.food_count < 0:
		Settings.food_coun = 0
	
	if initialized:
		if Settings.food_count < food_max:
			add_rand_food()
	

func initialize_fd():
	
	clear_fd()
		
	
	while Settings.food_count < food_max:
		add_rand_food()
	
	initialized = true

func add_rand_food():
	
	rand_index = randi() % data.size()
	rand_chunk = data.values()[rand_index]
	origin = data.keys()[rand_index] * CHUNK_SIZE
	rand_pos = rand_chunk.keys()[randi() % rand_chunk.size()]
	
	if rand_pos.y >= water_lvl:
		if !food_arr.has(rand_pos):
			if rand_chunk[rand_pos] == 3:
				
				if rand_chunk.has(rand_pos + Vector3.UP):
					if rand_chunk[rand_pos + Vector3.UP] == 11:
						return
				
				var odd = int(rand_pos.z)%2
				
				if odd:
					pos = (origin + rand_pos + Vector3(1,1,0.5)) * Vector3(1,1,HEX_OFFSET)
				else:
					pos = (origin + rand_pos + Vector3(0.5,1,0.5)) * Vector3(1,1,HEX_OFFSET)
				
				food_arr.append(rand_pos)
				
				var fd = food.instance()
				
				fd.transform.origin = pos
				fd.pos = rand_pos
				
				Settings.food_count += 1
				add_child(fd)
				

func clear_fd():
	
	initialized = false
	
	for f in get_children():
		food_arr.erase(f.pos) 
		
		for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.fd_list.has(f.area):
					creature.fd_list.erase(f.area)
		
		remove_child(f)
		f.queue_free()
		
		Settings.food_count -= 1
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.fd_list.clear()
		
	food_arr.clear()
	Settings.food_count = 0
