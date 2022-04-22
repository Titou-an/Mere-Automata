extends Spatial

signal quit
#warning-ignore:unused_signal
signal replace_scene

var chunk_x = (
	2 if Settings.world_size == Settings.WorldSizes.S2X2
	else 3 if Settings.world_size == Settings.WorldSizes.S3X3
	else 4
)
var chunk_z = (
	2 if Settings.world_size == Settings.WorldSizes.S2X2
	else 3 if Settings.world_size == Settings.WorldSizes.S3X3
	else 4
)
var chunk_y = 1

var world_seed = Settings.world_seed

onready var player = $PlayerFreeCam
onready var hotbar = player.get_node("UI/Hotbar")

onready var pause_menu = $PauseMenu

onready var world_generator = $World_Generator 
onready var spawner = $Spawner   
onready var food_parent = $Food_Control 

func _ready():
	
	food_parent.data = world_generator.chunk_data
	world_generator.gen_hex_map()

func _process(delta):
	# trigger 
	if Input.is_action_just_pressed("trigger_item"):
		var selected = hotbar.selected
		
		if selected == 0:
			var ray = player.get_node("RotationHelper/RayCast")
			ray.force_raycast_update()
			if ray.is_colliding():
				spawner.createCreatureAtPos(ray.get_collision_point() + Vector3(0,0.5,0))
		elif selected == 1:
			var ray = player.get_node("RotationHelper/RayCast")
			ray.force_raycast_update()
			
			if ray.is_colliding():
				var body = ray.get_collider()
				
				if body.has_method("death"):
					body.death()
				
		elif selected == 2:
			pass
		elif selected == 3:
			pass
		elif selected == 4:
			Engine.time_scale += 0.5
			
			if Engine.time_scale > 3:
				Engine.time_scale = 0.5
		elif selected == 5:
			pass
		elif selected == 6:
			pause_menu.show()
			
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			get_tree().paused = !get_tree().paused
	

func _input(event):
	
	if event.is_action_pressed("action_reload"):
		world_generator.clean_up()
	
	if event.is_action_pressed("action_hex_map"):
		world_generator.gen_hex_map()
	
	if event.is_action_pressed("action_cube_map"):
		world_generator.gen_cube_map()
	
	if event.is_action_pressed("create_food"):
		food_parent.initialize_fd(world_generator.chunk_data)
	
	if event.is_action_pressed("ui_left"):
		var menu_scene = PackedScene.new()
		menu_scene.pack(get_tree().get_current_scene().get_node("World"))
		ResourceSaver.save("res://Menu/background.tscn", menu_scene)

	if event.is_action_pressed("ui_up"):
		spawner.createCreature()
