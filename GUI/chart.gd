extends Control

onready var chart_graph = $Chart
var x = 0

var data = {}
var prediction1 = 0.0
var prediction2 = 0.0

func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		Predicted1 = Color(1,1,1),
		Predicted2 = Color(0.5,0.5,0.5),
		Species1 = Color8(103,69,147),
		Species2 = Color8(152,71,158),
	})
	chart_graph.set_labels(6)

func _on_Timer_timeout():
	
	chart_graph.create_new_point({
		label = String(x),
		values = {
			Predicted1 = prediction1,
			Predicted2 = prediction2,
			Species1 = Settings.species1_count,
			Species2 = Settings.species2_count
		}
	})
	
	prediction1 =  Settings.species1_count+ (((Settings.births1/(x+5.0)) * Settings.species1_count)-((Settings.deaths1/(x+5.0)) * Settings.species1_count * Settings.species2_count))
	prediction2 =  Settings.species2_count+ ((-(Settings.deaths2/(x+5.0)) * Settings.species2_count)+((Settings.births2/(x+5.0)) * Settings.species1_count * Settings.species2_count))
	
	

	data[x] = [Settings.species1_count,Settings.species2_count,Settings.creature_count]
	x += 5
