extends Control

onready var hotbar = $HbSlots
onready var slots = hotbar.get_children()

var unselected = Color(0.75,0.75,0.75)
var selected = 0

var sel_msg = "Nothing selected"

func _ready():
	
	for s in slots:
		s.modulate = unselected
	

func _process(delta):
	
	if Input.is_action_just_released("shift_item_down"):
		slots[selected].modulate = unselected
		selected += 1
		if selected > (slots.size() -1):
			selected = 0
		
	if Input.is_action_just_released("shift_item_up"):
		slots[selected].modulate = unselected
		selected -= 1
		if selected < (0):
			selected = slots.size() -1
		
		
	
	if Input.is_key_pressed(KEY_1):
		slots[selected].modulate = unselected
		selected = 0
	if Input.is_key_pressed(KEY_2):
		slots[selected].modulate = unselected
		selected = 1
	if Input.is_key_pressed(KEY_3):
		slots[selected].modulate = unselected
		selected = 2
	if Input.is_key_pressed(KEY_4):
		slots[selected].modulate = unselected
		selected = 3
	if Input.is_key_pressed(KEY_5):
		slots[selected].modulate = unselected
		selected = 4
	if Input.is_key_pressed(KEY_6):
		slots[selected].modulate = unselected
		selected = 5
	if Input.is_key_pressed(KEY_7):
		slots[selected].modulate = unselected
		selected = 6
	
	
	slots[selected].modulate = Color(1,1,1)
	
	sel_msg = (
		"Add a creature" if selected == 0
		else "Remove a creature" if selected == 1
		else "Species settings" if selected == 2
		else "Edit genes" if selected == 3
		else "Timescale x" + String(Engine.time_scale) if selected == 4
		else "Graph settings" if selected == 5
		else "Menu" if selected == 6
		else "Nothing Selected" 
	)
	
	$Selection.text = sel_msg
	
