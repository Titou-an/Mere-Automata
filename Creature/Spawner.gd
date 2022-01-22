extends Node
# var dec
var xcord
var zcord
var timer = 0
var timer_limit = 2
var rng = RandomNumberGenerator.new()
var scene = load("res://Creature/Creature.tscn")
func _ready():
	print("yo")
	
	# Spawn i amount of creature in genesis gen
#	for i in 20:
#		var player = scene.instance()
#		add_child(player)
#		xcord = rand_range(0, 48)
#		zcord = rand_range(0, 48)
#		player.transform.origin = Vector3(xcord, 15, zcord)
#		rng.randomize()
#		var numba = rng.randf_range(0, 10.0)
#		player.rotation = Vector3(0, numba , 0)

	
	
func _physics_process(delta):
	timer += delta
	if (timer > timer_limit):
		
		timer = 0
		var player = scene.instance()
		add_child(player)
		xcord = rand_range(0, 48)
		zcord = rand_range(0, 48)
		player.transform.origin = Vector3(xcord, 15, zcord)
		rng.randomize()
		var numba = rng.randf_range(0, 10.0)
		player.rotation = Vector3(0, numba , 0)
