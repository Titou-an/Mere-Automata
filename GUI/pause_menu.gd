extends Control

onready var world_generator = get_node("../World_Generator")

func _process(delta):
	# Cursor capture
	if Input.is_action_just_pressed("ui_cancel"):
		
		visible = !visible
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		get_tree().paused = !get_tree().paused


func _on_Exit_pressed():
	
	world_generator.clean_up()
	get_tree().quit()


func _on_Resume_pressed():
	
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func _on_MainMenu_pressed():
	
	get_tree().paused = !get_tree().paused
	world_generator.clean_up()
	get_tree().get_current_scene().call_deferred("go_to_main_menu")
