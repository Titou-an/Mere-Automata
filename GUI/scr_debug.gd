extends Control

func _ready():
	 $OS_Label.text = "OS: " + OS.get_name()
	 $Build_Label.text = "Build version: " + ProjectSettings.get_setting("application/config/build_version")
	 $Engine_Label.text = "Godot version: " + Engine.get_version_info()["string"]


func _process(delta):
	$FPS_Label.text = "FPS: " + str(Engine.get_frames_per_second())
	$Memory_Label.text = "Memory: " + "%3.2f" % (OS.get_static_memory_usage() / 1048576.0) + " MiB"
	$Count_Label.text = "Creature count: " +  String(Spawner.count)

func _input(event):
	
	# Toggle Visibility
	
	if event.is_action_pressed("toggle_debug"):
		visible = !visible
		
	
	#------------------------------------------------------------------
	# Toggle Saving
	
#	if Input.is_action_just_pressed("debug_save"):
#		saveGame()
#	if Input.is_action_just_pressed("debug_load"):
#		loadGame()

	#------------------------------------------------------------------
	# Toggle Pause
	
	if event.is_action_pressed("debug_pause"):
		get_tree().paused = !get_tree().paused
		
	#------------------------------------------------------------------
	# Toggle Fullscreen
	
	if event.is_action_pressed("toggle_flscr"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	#------------------------------------------------------------------
	

func saveGame():
	var save_game = File.new()

	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")

	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
			 # Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		 # Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func loadGame():
	var save_game = File.new()
	if  !save_game.file_exists("user://savegame.save"):
		print("Error! No save to load.")
		return 

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("persist")

	for i in save_nodes:
		i.queue_free()

	 #Load the file line by line and process that dictionary to restore
	 #the object it represents.
	save_game.open("user://savegame.save", File.READ)

	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		new_object.add_to_group("Persist")
		get_node(node_data["parent"]).add_child(new_object)
		new_object.translation = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])

		 #Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			new_object.set(i, node_data[i])

	save_game.close()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"visible" : is_visible()
	}
	return save_dict
