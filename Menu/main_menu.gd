extends Control

signal replace_scene
signal quit

var res_loader: ResourceInteractiveLoader = null
var loading_thread: Thread = null

onready var title = $DefaultButtons
onready var start = $StartGame
onready var loading = $Loading

onready var ws_2x2 = start.get_node("Panel/StartButtons/WorldSize/2x2")
onready var ws_3x3 = start.get_node("Panel/StartButtons/WorldSize/3x3")
onready var ws_4x4 = start.get_node("Panel/StartButtons/WorldSize/4x4")

onready var loading_progress = loading.get_node("ProgressBar")
onready var loading_done_timer = loading.get_node("Timer")
var world_size = 0

func _on_Exit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	title.visible = false
	start.visible = true


func _on_Back_pressed():
	title.visible = true
	start.visible = false


func _on_CreateWorld_pressed():
	var world_seed = str2var($StartGame/Panel/StartButtons/SeedSettings/LineEdit.text)
	
	if typeof(world_seed) != 2:
		world_seed = 1
	
	if ws_2x2.pressed:
		world_size = 0
	elif ws_3x3.pressed:
		world_size = 1
	elif ws_3x3.pressed:
		world_size = 2
	
	loading.show()
	
	var path = "res://World/World.tscn"
	
	if ResourceLoader.has_cached(path):
		emit_signal("replace_scene", ResourceLoader.load(path))
	else: 
		res_loader = ResourceLoader.load_interactive(path)
		loading_thread = Thread.new()
		
		loading_thread.start(self, "interactive_load", res_loader)

func interactive_load(loader):
	while true:
		var status = loader.poll()
		if status == OK:
			loading_progress.value = (loader.get_stage() * 100) / loader.get_stage_count()
			continue
		elif status == ERR_FILE_EOF:
			loading_progress.value = 100
			loading_done_timer.start()
			break
		else:
			print("Error while loading level: " + str(status))
			loading.hide()
			break

func _on_Timer_timeout():
	loading_done(res_loader)

func loading_done(loader):
	loading_thread.wait_to_finish()
	emit_signal("replace_scene", loader.get_resource())
	print(1)
	res_loader = null
