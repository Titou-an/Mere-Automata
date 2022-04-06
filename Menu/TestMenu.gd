extends Control

onready var seed_box = $LineEdit

func _on_Button_button_up():
	var seed_val = int(seed_box.text)
	
	if seed_val == null:
		seed_val = 0
	
	$Button.disabled = true
	
	print(seed_val)
