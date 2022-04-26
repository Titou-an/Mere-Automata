extends Spatial

var regen = Settings.food_regen

var pos = Vector3()
onready var area = $Area

func _ready():
	randomize()
	var offset = rand_range(0,$AnimationPlayer.current_animation_length)
	$AnimationPlayer.advance(offset)

func _on_Area_body_entered(body):
	
	if body.has_method("get_energy"):
		if !body.genes["diet"] == Settings.Diets.CARNIVORE:
			if body.get_energy() < body.max_energy:
				if body.get_energy() + regen > body.max_energy:
					body.set_energy(body.max_energy)
				else:
					body.set_energy(body.get_energy() + regen)
				
				clean()
			
		

func clean():
	
	get_parent().food_arr.erase(pos)
	
	for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.fd_list.has(area):
					creature.fd_list.erase(area)
		
	Settings.food_count -= 1
	queue_free()
