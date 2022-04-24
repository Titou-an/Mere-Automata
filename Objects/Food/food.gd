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
		if body.get_energy() < 100:
			if body.get_energy() + regen > 100:
				body.set_energy(100)
			else:
				body.set_energy(body.get_energy() + regen)
			
			clean()
			
		

func clean():
	Settings.food_count -= 1
	get_parent().food_arr.erase(pos)
	
	for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.fd_list.has(area):
					creature.fd_list.erase(area)
	queue_free()
