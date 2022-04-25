extends Spatial

const regen = 50

var pos = Vector3()
onready var area = $Area

func _on_Area_body_entered(body):
	
	if body.has_method("get_energy"):
<<<<<<< Updated upstream
		if body.get_energy() < 100:
			if body.get_energy() + regen > 100:
				body.set_energy(100)
			else:
				body.set_energy(body.get_energy() + regen)
			
			clean()
=======
		if body.genes["species"] != Settings.Diets.CARNIVORE:
			if body.get_energy() < body.max_energy:
				if body.get_energy() + regen > body.max_energy:
					body.set_energy(body.max_energy)
				else:
					body.set_energy(body.get_energy() + regen)
				
				clean()
>>>>>>> Stashed changes
			
		

func clean():
	get_parent().food_amnt -= 1
	get_parent().food_arr.erase(pos)
	
	for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.fd_list.has(area):
					creature.fd_list.erase(area)
	queue_free()
