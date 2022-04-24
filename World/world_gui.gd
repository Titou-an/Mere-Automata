extends Control

onready var  player_ui = get_node("../PlayerFreeCam/UI")

func _process(_delta):
	# Cursor capture
	
		if Input.is_action_just_pressed("ui_cancel"):
			
			if get_tree().paused:
				for m in get_children():
					m.hide()
					
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				get_tree().paused = false
				
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_node("PauseMenu").show()
				get_tree().paused = true
			
			
			player_ui.visible = !player_ui.visible
			
		
			
		if get_tree().paused:
			if Input.is_action_just_pressed("toggle_flscr"):
				OS.window_fullscreen = !OS.window_fullscreen
				
			
