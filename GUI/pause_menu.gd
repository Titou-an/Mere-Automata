extends Control

onready var world_generator = get_node("../../World_Generator")

onready var  player_ui = get_node("../../PlayerFreeCam/UI")

func _on_Exit_pressed():
	
	world_generator.clean_up()
	get_tree().quit()


func _on_Resume_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func _on_MainMenu_pressed():
	
	Settings.species1_count = 0
	Settings.species2_count = 0
	Settings.creature_count = 0
	Engine.time_scale = 1
	get_tree().paused = false
	world_generator.clean_up()
	get_tree().get_current_scene().call_deferred("go_to_main_menu")
