extends Control

onready var chart_graph = $Chart
var x = 0

var data = {}

func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		Total = Color(1,1,1),
		Species1 = Color8(103,69,147),
		Species2 = Color8(152,71,158),
	})
	chart_graph.set_labels(6)

func _on_Timer_timeout():
	chart_graph.create_new_point({
		label = String(x),
		values = {
			Total = Settings.creature_count,
			Species1 = Settings.species1_count,
			Species2 = Settings.species2_count
		}
	})
	data[x] = [Settings.species1_count,Settings.species2_count,Settings.creature_count]
	x += 5
