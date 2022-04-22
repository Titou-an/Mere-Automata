extends Node

enum WorldSizes {
	S2X2 = 0
	S3X3 = 1
	S4X4 = 2
}

var world_seed = 1
var world_size = WorldSizes.S2X2

func _ready():
	load_settings()

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
