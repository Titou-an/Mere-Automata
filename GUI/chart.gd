extends Control

onready var chart_graph = $Chart
var x = 0
func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		Total = Color(1,0,1),
		Species1 = Color(0,1,1),
		Species2 = Color(1,1,0)
	})
	chart_graph.set_labels(7)

func _on_Timer_timeout():
	chart_graph.create_new_point({
		label = String(x),
		values = {
			Total = Settings.creature_count,
			Species1 = Settings.species1_count,
			Species2 = Settings.species2_count
		}
	})
	
	x += 5
