extends Spatial

signal quit
#warning-ignore:unused_signal
signal replace_scene

var chunk_x = 2
var chunk_y = 1
var chunk_z = 2

export var world_seed = 1

onready var world_generator = $World_Generator
onready var spawner = $Spawner
onready var food_parent = $Food_Control

func _ready():
	world_seed = Settings.world_seed
	
	if Settings.world_size == Settings.WorldSizes.S2X2:
		chunk_x = 2
		chunk_z = 2
	elif Settings.world_size == Settings.WorldSizes.S3X3:
		chunk_x = 3
		chunk_z = 3
	elif Settings.world_size == Settings.WorldSizes.S4X4:
		chunk_x = 4
		chunk_z = 4
	
	food_parent.data = world_generator.chunk_data
	
	world_generator.gen_hex_map()

func _input(event):
	
	if event.is_action_pressed("action_reload"):
		world_generator.clean_up()
	
	if event.is_action_pressed("action_hex_test"):
		world_generator.gen_hex_test()
		
	if event.is_action_pressed("action_hex_map"):
		world_generator.gen_hex_map()
	
	if event.is_action_pressed("action_cube_map"):
		world_generator.gen_cube_map()
	
	if event.is_action_pressed("action_reload"):
		world_generator.clean_up()
	
	if event.is_action_pressed("create_food"):
		food_parent.initialize_fd(world_generator.chunk_data)
	
#	if event.is_action_pressed("ui_left"):
#		var menu_scene = PackedScene.new()
#		menu_scene.pack(get_tree().get_current_scene())
#		ResourceSaver.save("res://Menu/MainMenu.tscn", menu_scene)
#
	if event.is_action_pressed("ui_up"):
		spawner.createCreature()


