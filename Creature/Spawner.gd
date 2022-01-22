extends Node
# var dec
var xcord
var zcord
func _ready():
	print("yo")
	var scene = load("res://Creature/Creature.tscn")
	# Spawn i amount of creature in genesis gen
	for i in 20:
		var player = scene.instance()
		add_child(player)
		xcord = rand_range(0, 48)
		zcord = rand_range(0, 48)
		player.transform.origin = Vector3(xcord, 15, zcord)
	
	
