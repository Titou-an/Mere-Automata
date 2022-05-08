extends Spatial

signal quit
#warning-ignore:unused_signal
signal replace_scene

onready var player = $PlayerFreeCam
onready var player_ui = player.get_node("UI")
onready var hotbar = player_ui.get_node("Hotbar")

onready var pause_menu = $World_GUI/PauseMenu
onready var gene_editor = $World_GUI/GeneEditor
onready var species_editor = $World_GUI/SpeciesTab
onready var chart_options = $World_GUI/ChartOptions

onready var world_generator = $World_Generator 
onready var spawner = $Spawner   
onready var food_control = $Food_Control 

var input_enabled = true

func _ready():
	
	food_control.data = world_generator.chunk_data
	world_generator.gen_hex_map()
	
	food_control.initialize_fd()

func _physics_process(_delta):
	# trigger 
	
	if input_enabled:
		if Input.is_action_just_pressed("trigger_item"):
			var selected = hotbar.selected
			
			if selected == 0:
				if (int(Settings.spc1_enabled) + int(Settings.spc2_enabled)):
					var ray = player.get_node("RotationHelper/RayCast")
					ray.force_raycast_update()
					if ray.is_colliding():
						
						var genes = (
							Settings.species1_genes if (Settings.spc1_enabled and !Settings.spc2_enabled)
							else Settings.species2_genes if (!Settings.spc1_enabled and Settings.spc2_enabled)
							else Settings.species1_genes if randi() % 2 
							else Settings.species2_genes
						)
						randomize()
						spawner.createCreatureAtPos(ray.get_collision_point() + Vector3(0,0.5,0),genes)
						
			elif selected == 1:
				var ray = player.get_node("RotationHelper/RayCast")
				ray.force_raycast_update()
				
				if ray.is_colliding():
					var body = ray.get_collider()
					
					if body.has_method("death"):
						body.death()
					
			elif selected == 2:
				player_ui.hide()
				species_editor.show()
				
				if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
				get_tree().paused = !get_tree().paused
		
			elif selected == 3:
				var ray = player.get_node("RotationHelper/RayCast")
				ray.force_raycast_update()
				
				if ray.is_colliding():
					var body = ray.get_collider()
					
					if body.has_method("death"):
						player_ui.hide()
						gene_editor.show()
						
						gene_editor.update_info(body)
						
						if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
							Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
						else:
							Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
						
						get_tree().paused = !get_tree().paused
		
			elif selected == 4:
				Engine.time_scale += 0.5
				
				if Engine.time_scale > 3:
					Engine.time_scale = 0.5
			elif selected == 5:
				player_ui.hide()
				chart_options.show()
				
				if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
				get_tree().paused = !get_tree().paused
			elif selected == 6:
				player_ui.hide()
				pause_menu.show()
				
				if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
				get_tree().paused = !get_tree().paused
		

func _input(event):
	
#	if event.is_action_pressed("action_hex_map"):
#		world_generator.gen_hex_map()
#
#	if event.is_action_pressed("action_cube_map"):
#		world_generator.gen_cube_map()
#
	if event.is_action_pressed("action_reload"):
		food_control.initialize_fd()
	
#	if event.is_action_pressed("ui_left"):
#		var menu_scene = PackedScene.new()
#		menu_scene.pack(get_tree().get_current_scene().get_node("World"))
#		ResourceSaver.save("res://Menu/background.tscn", menu_scene)
