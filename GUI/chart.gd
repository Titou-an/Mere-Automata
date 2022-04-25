extends Control

onready var chart_graph = $Chart
var x = 0
func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		species = Color(1,1, 1)
	})
	chart_graph.set_labels(7)

func _on_Timer_timeout():
	chart_graph.create_new_point({
		label = String(x),
		values = {
		  species = Settings.creature_count
		}
	})
	
	x += 5
