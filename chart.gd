extends Control

onready var chart = $Chart

func _ready():
	
	chart.initialize(chart.LABELS_TO_SHOW.Y_LABEL,{
		
		Species1 = Color(1.0,0,1.0)
		
	})
	
	reset()
	#set_process(true)
	


func reset():
  chart.create_new_point({
	label = '1',
	values = {
	  Species1 = 150
	}
  })

  chart.create_new_point({
	label = '2',
	values = {
	  Species1 = 500
	}
  })

  chart.create_new_point({
	label = '3',
	values = {
	  Species1 = 10
	}
  })

  chart.create_new_point({
	label = '4',
	values = {
	  Species1 = 350
	}
  })

  chart.create_new_point({
	label = '5',
	values = {
	  Species1 = 1350
	}
  })

  chart.create_new_point({
	label = '6',
	values = {
	  Species1 = 350
	}
  })

  chart.create_new_point({
	label = '7',
	values = {
	  Species1 = 100
	}
  })

  chart.create_new_point({
	label = '8',
	values = {
	  Species1 = 350
	}
  })

func _exit_tree():
	
	chart.clear_data()
