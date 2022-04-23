extends Control

onready var  player_ui = get_node("../../PlayerFreeCam/UI")

onready var species1 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species1
onready var species2 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species2




func _on_Kill_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.death()


func _on_Back_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	


func _on_Apply_pressed():
	pass # Replace with function body.
