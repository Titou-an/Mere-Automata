extends Control

onready var  player_ui = get_node("../../PlayerFreeCam/UI")
onready var chart_ui = get_node("../../ChartControl")
onready var file_dialog = $CenterContainer/FileDialog

var export_type = 0
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
	export_type = 0
	file_dialog.current_file = "new_population_data.csv"
	file_dialog.show()
	

func _on_Export2_pressed():
	export_type = 1
	file_dialog.current_file = "new_gene_data.csv"
	file_dialog.show()


func _on_FileDialog_file_selected(path):
	var f = File.new()
	var error = f.open(path, File.WRITE)
	#assert(not error)
	
	if export_type == 0:
		var data = chart_ui.data
		
		f.store_line("Time,Species1,Species2,Total")
		for point in data.keys():
			
			f.store_line(String(point) + "," + 
			String(data[point][0]) + "," + 
			String(data[point][1]) + "," + 
			String(data[point][2]))
	else:
		f.store_line("ID#,Species,Diet,Mutation Offset,Speed,Vision Radius,Size")
		
		for c in get_tree().get_nodes_in_group("creatures"):
			
			var species = "Species#1" if c.genes["species"] == Settings.Species.SPECIES1 else "Species#2"
			var diet = (
				"Herbivore" if c.genes["diet"] == Settings.Diets.HERBIVORE
				else "Carnivore" if c.genes["diet"] == Settings.Diets.CARNIVORE
				else "Omnivore"
			)
			
			f.store_line(String(c.get_instance_id()) + "," +
			species + "," +
			diet + "," +
			String(c.genes["mutation"]) + "," +
			String(c.genes["speed"]) + "," +
			String(c.genes["vision"]) + "," +
			String(c.genes["size"]) + "," 
			)

