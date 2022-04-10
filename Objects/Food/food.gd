extends Spatial

const regen = 50

onready var area = $Area

func _on_Area_body_entered(body):
	
	if body.has_method("get_energy"):
		if body.get_energy() < 100:
			if body.get_energy() + regen > 100:
				body.set_energy(100)
			else:
				body.set_energy(body.get_energy() + regen)
			
			clean()
			
		

func clean():
	self.queue_free()
	for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.targ_list.has(area):
					creature.remove_tg(area)
