extends Node


# World Parameters
enum WorldSizes {
	S2X2 = 2
	S3X3 = 3
	S4X4 = 4
}

var world_seed = 1447 # Seed value used for main menu background
var food_min = 50
var food_regen = 50
var world_size = WorldSizes.S2X2

# Simulation parameters
enum Species {
	SPECIES1 = 0,
	SPECIES2 = 1
}

enum Diets {
	HERBIVORE = 0,
	CARNIVORE = 1,
	OMNIVORE = 2
}

var food_count = 0
var creature_count = 0
var species1_count = 0
var species2_count = 0

var species1_genes = {
	"species" : Species.SPECIES1,
	"diet" : Diets.HERBIVORE,
	"vision" : 2.0,
	"speed" : 2.0,
	"size" : 1.0,
	"mutation" : 0.1
}

var species1_enabled_genes = {
	"vision" : true,
	"speed" : true,
	"size" : true
}

var spc1_enabled = true
var init_energy1 = 65 # Default energy value for species 1
var init_population1 = 10 # Default population value for species 1


var species2_genes = {
	"species" : Species.SPECIES2,
	"diet" : Diets.HERBIVORE,
	"vision" : 2.0,
	"speed" : 2.0,
	"size" : 1.0,
	"mutation" : 0.1
}

var species2_enabled_genes = {
	"vision" : true,
	"speed" : true,
	"size" : true
}

var spc2_enabled = false
var init_energy2 = 65 # Default energy value for species 2
var init_population2 = 10 # Default population value for species 2

func _ready():
	pass
	#load_settings()

func _input(event):
	
	#------------------------------------------------------------------
	# Toggle Fullscreen
	
	if event.is_action_pressed("toggle_flscr"):
		OS.window_fullscreen = !OS.window_fullscreen
		get_tree().set_input_as_handled()
		
	#------------------------------------------------------------------
	

func save_settings():
	var f = File.new()
	var error = f.open("user://settings.json", File.WRITE)
	assert(not error)

	var d = { 
	"worldSeed": world_seed, 
	"worldSize": world_size
	}
	f.store_line(to_json(d))
	

func load_settings():
	var f = File.new()
	var error = f.open("user://settings.json", File.READ)
	if error:
		print("There are no settings to load.")
		return

	var d = parse_json(f.get_as_text())
	if typeof(d) != TYPE_DICTIONARY:
		return

	if "world seed" in d:
		world_seed = int(d.worldSeed)

	if "world size" in d:
		world_size = int(d.worldSize)
