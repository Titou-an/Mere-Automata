extends Spatial

var pos = Vector3()
onready var area = $Area

onready var food_control = get_parent()
var mutex

func _ready():
	mutex = food_control.mutex
	randomize()
	var offset = rand_range(0,$AnimationPlayer.current_animation_length)
	$AnimationPlayer.advance(offset)

func _on_Area_body_entered(body):
	if body.has_method("regen"):
		if !body.genes["diet"] == Settings.Diets.CARNIVORE:
			clean()
			body.regen()
			

func clean():
	food_control.food_arr.erase(pos)
	for creature in get_tree().get_nodes_in_group("creatures"):
				if creature.fd_list.has(area):
					creature.fd_list.erase(area)
		
	queue_free()
	
	mutex.lock()
	Settings.food_count -= 1
	mutex.unlock()
	
