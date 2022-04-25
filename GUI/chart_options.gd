extends Control

onready var  player_ui = get_node("../../PlayerFreeCam/UI")
onready var chart_ui = get_node("../../ChartControl")
onready var file_dialog = $CenterContainer/FileDialog

#func _ready():
#	var directory = Directory.new( )
#	directory.make_dir("res://simulation_data")

func _on_Back_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_ShowChart_toggled(button_pressed):
	chart_ui.visible = button_pressed

func _on_Export_pressed():
	file_dialog.current_file = "new_sim_data.csv"
	file_dialog.show()
	



func _on_FileDialog_file_selected(path):
	var f = File.new()
	var error = f.open(path, File.WRITE)
	#assert(not error)
	
	var data = chart_ui.data
	
	f.store_line("Time,Species1,Species2,Total")
	for point in data.keys():
		
		f.store_line(String(point) + "," + String(data[point][0]) + "," +String(data[point][1]) + "," + String(data[point][2]))
