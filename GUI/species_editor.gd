extends Control

onready var  player_ui = get_node("../../PlayerFreeCam/UI")
onready var spawner = get_node("../../Spawner")

var rng = RandomNumberGenerator.new()

onready var species1 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species1/Genes/Inputs
onready var species2 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species2/Genes/Inputs

# Enables Species
onready var spc1_enabled = species1.get_node("sp1Enabled")
onready var spc2_enabled = species2.get_node("sp2Enabled")

# Initial Population Values
onready var init_pop_val1 = species1.get_node("Population")
onready var init_pop_val2 = species2.get_node("Population")

# Initial Energy Values
onready var init_nrg_val1 = species1.get_node("Energy")
onready var init_nrg_val2 = species2.get_node("Energy")

# Initial Speed Values
onready var init_spd_val1 = species1.get_node("HBoxContainer/Speed")
onready var init_spd_val2 = species2.get_node("HBoxContainer/Speed")

# Speed Mutations Enabled
onready var spd1_enabled = species1.get_node("HBoxContainer/SpeedEnabled")
onready var spd2_enabled = species2.get_node("HBoxContainer/SpeedEnabled")

# Initial Vision Values
onready var init_vis_val1 = species1.get_node("HBoxContainer2/Vision")
onready var init_vis_val2 = species2.get_node("HBoxContainer2/Vision")

# Vision Mutations Enabled
onready var vis1_enabled = species1.get_node("HBoxContainer2/VisionEnabled")
onready var vis2_enabled = species2.get_node("HBoxContainer2/VisionEnabled")

# Initial Size Values
onready var init_siz_val1 = species1.get_node("HBoxContainer3/Size")
onready var init_siz_val2 = species2.get_node("HBoxContainer3/Size")

# Size Mutations Enabled
onready var siz1_enabled = species1.get_node("HBoxContainer3/SizeEnabled")
onready var siz2_enabled = species2.get_node("HBoxContainer3/SizeEnabled")

# Mutation Values
onready var mut_val1 = species1.get_node("Mutation")
onready var mut_val2 = species2.get_node("Mutation")

# Diets 
onready var herb1 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species1/Diet/Herb
onready var herb2 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species2/Diet/Herb

onready var carn1 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species1/Diet/Carn
onready var carn2 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species2/Diet/Carn

onready var omni1 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species1/Diet/Omni
onready var omni2 = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/Species/Species2/Diet/Omni

onready var chart = get_node("../../ChartControl")

func _ready():
	
	init_pop_val1.placeholder_text = String(Settings.init_population1)
	init_nrg_val1.placeholder_text =  String(Settings.init_energy1)
	init_spd_val1.placeholder_text =  String(Settings.species1_genes["speed"])
	init_vis_val1.placeholder_text =  String(Settings.species1_genes["vision"])
	init_siz_val1.placeholder_text =  String(Settings.species1_genes["size"])
	mut_val1.placeholder_text =  String(Settings.species1_genes["mutation"])
	spd1_enabled.pressed = Settings.species1_enabled_genes["speed"]
	vis1_enabled.pressed = Settings.species1_enabled_genes["vision"]
	siz1_enabled.pressed = Settings.species1_enabled_genes["size"]
	spc1_enabled.pressed = Settings.spc1_enabled
	
	if Settings.species1_genes["diet"] == Settings.Diets.HERBIVORE:
		herb1.pressed = true
	elif Settings.species1_genes["diet"] == Settings.Diets.CARNIVORE:
		carn1.pressed = true
	else:
		omni1.pressed = true
		
	
	init_pop_val2.placeholder_text = String(Settings.init_population2)
	init_nrg_val2.placeholder_text =  String(Settings.init_energy2)
	init_spd_val2.placeholder_text =  String(Settings.species2_genes["speed"])
	init_vis_val2.placeholder_text =  String(Settings.species2_genes["vision"])
	init_siz_val2.placeholder_text =  String(Settings.species2_genes["size"])
	mut_val2.placeholder_text =  String(Settings.species2_genes["mutation"])
	spd2_enabled.pressed = Settings.species2_enabled_genes["speed"]
	vis2_enabled.pressed = Settings.species2_enabled_genes["vision"]
	siz2_enabled.pressed = Settings.species2_enabled_genes["size"]
	spc2_enabled.pressed = Settings.spc2_enabled
	
	if Settings.species2_genes["diet"] == Settings.Diets.HERBIVORE:
		herb2.pressed = true
	elif Settings.species2_genes["diet"] == Settings.Diets.CARNIVORE:
		carn2.pressed = true
	else:
		omni2.pressed = true

func _on_Kill_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.death()


func _on_Back_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	


func _on_Apply_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Species 1 genes
	
	if typeof(str2var(init_nrg_val1.text)) == TYPE_REAL or typeof(str2var(init_nrg_val1.text)) == TYPE_INT:
		Settings.init_energy1 = str2var(init_nrg_val1.text)
	if typeof(str2var(init_pop_val1.text)) == TYPE_INT:
		Settings.init_population1 = str2var(init_pop_val1.text)
	if typeof(str2var(init_spd_val1.text)) == TYPE_REAL or typeof(str2var(init_spd_val1.text)) == TYPE_INT:
		Settings.species1_genes["speed"] = str2var(init_spd_val1.text)
	if typeof(str2var(init_vis_val1.text)) == TYPE_REAL or typeof(str2var(init_vis_val1.text)) == TYPE_INT:
		Settings.species1_genes["vision"] = str2var(init_vis_val1.text)
	if typeof(str2var(init_siz_val1.text)) == TYPE_REAL or typeof(str2var(init_siz_val1.text)) == TYPE_INT:
		Settings.species1_genes["size"] = str2var(init_siz_val1.text)
	if typeof(str2var(mut_val1.text)) == TYPE_REAL or typeof(str2var(mut_val1.text)) == TYPE_INT:
		Settings.species1_genes["mutation"] = str2var(mut_val1.text)
	
	if herb1.pressed:
		Settings.species1_genes["diet"] = Settings.Diets.HERBIVORE
	elif carn1.pressed:
		Settings.species1_genes["diet"] = Settings.Diets.CARNIVORE
	else:
		Settings.species1_genes["diet"] = Settings.Diets.OMNIVORE
	
	Settings.species1_enabled_genes["speed"] = true if spd1_enabled.pressed else false
	Settings.species1_enabled_genes["vision"] = true if vis1_enabled.pressed else false
	Settings.species1_enabled_genes["size"] = true if siz1_enabled.pressed else false
	
	
	# Species 2 genes
	
	if typeof(str2var(init_nrg_val2.text)) == TYPE_REAL or typeof(str2var(init_nrg_val2.text)) == TYPE_INT:
		Settings.init_energy2 = str2var(init_nrg_val2.text)
	if  typeof(str2var(init_pop_val2.text)) == TYPE_INT:
		Settings.init_population2 = str2var(init_pop_val2.text)
	if typeof(str2var(init_spd_val2.text)) == TYPE_REAL or typeof(str2var(init_spd_val2.text)) == TYPE_INT:
		Settings.species2_genes["speed"] = str2var(init_spd_val2.text)
	if typeof(str2var(init_vis_val2.text)) == TYPE_REAL or typeof(str2var(init_vis_val2.text)) == TYPE_INT:
		Settings.species2_genes["vision"] = str2var(init_vis_val2.text)
	if typeof(str2var(init_siz_val2.text)) == TYPE_REAL or typeof(str2var(init_siz_val2.text)) == TYPE_INT:
		Settings.species2_genes["size"] = str2var(init_siz_val2.text)
	if typeof(str2var(mut_val2.text)) == TYPE_REAL or typeof(str2var(mut_val2.text)) == TYPE_INT:
		Settings.species2_genes["mutation"] = str2var(mut_val2.text)
	
	if herb2.pressed:
		Settings.species2_genes["diet"] = Settings.Diets.HERBIVORE
	elif carn2.pressed:
		Settings.species2_genes["diet"] = Settings.Diets.CARNIVORE
	else:
		Settings.species2_genes["diet"] = Settings.Diets.OMNIVORE
	
	
	Settings.species2_enabled_genes["speed"] = true if spd2_enabled.pressed else false
	Settings.species2_enabled_genes["vision"] = true if vis2_enabled.pressed else false
	Settings.species2_enabled_genes["size"] = true if siz2_enabled.pressed else false
	
	get_tree().paused = false
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.death()
	
	chart.get_node("Chart").clear_chart()
	Settings.births1 = 0 
	Settings.births2 = 0
	Settings.deaths1 = 0
	Settings.deaths2 = 0
	chart.x = 0
	
	if spc1_enabled.pressed:
		for crt in Settings.init_population1:
			spawner.createCreatureRand(Settings.species1_genes)
	
	if spc2_enabled.pressed:
		for crt in Settings.init_population2:
			spawner.createCreatureRand(Settings.species2_genes)
	
func _on_sp1Enabled_toggled(button_pressed):
	
	Settings.spc1_enabled = button_pressed
	init_pop_val1.editable = button_pressed
	init_nrg_val1.editable = button_pressed
	init_spd_val1.editable = button_pressed
	init_vis_val1.editable = button_pressed
	init_siz_val1.editable = button_pressed
	mut_val1.editable = button_pressed
	spd1_enabled.disabled = !button_pressed
	vis1_enabled.disabled = !button_pressed
	siz1_enabled.disabled = !button_pressed
	herb1.disabled = !button_pressed
	carn1.disabled = !button_pressed
	omni1.disabled = !button_pressed

func _on_sp2Enabled_toggled(button_pressed):
	Settings.spc2_enabled = button_pressed
	init_pop_val2.editable = button_pressed
	init_nrg_val2.editable = button_pressed
	init_spd_val2.editable = button_pressed
	init_vis_val2.editable = button_pressed
	init_siz_val2.editable = button_pressed
	mut_val2.editable = button_pressed
	spd2_enabled.disabled = !button_pressed
	vis2_enabled.disabled = !button_pressed
	siz2_enabled.disabled = !button_pressed
	herb2.disabled = !button_pressed
	carn2.disabled = !button_pressed
	omni2.disabled = !button_pressed

func _on_ApplyRand_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Species 1 genes
	
	if typeof(str2var(init_nrg_val1.text)) == TYPE_REAL or typeof(str2var(init_nrg_val1.text)) == TYPE_INT:
		Settings.init_energy1 = str2var(init_nrg_val1.text)
	if typeof(str2var(init_pop_val1.text)) == TYPE_INT:
		Settings.init_population1 = str2var(init_pop_val1.text)
	if typeof(str2var(mut_val1.text)) == TYPE_REAL or typeof(str2var(mut_val1.text)) == TYPE_INT:
		Settings.species1_genes["mutation"] = str2var(mut_val1.text)
	
	
	if herb1.pressed:
		Settings.species1_genes["diet"] = Settings.Diets.HERBIVORE
	elif carn1.pressed:
		Settings.species1_genes["diet"] = Settings.Diets.CARNIVORE
	else:
		Settings.species1_genes["diet"] = Settings.Diets.OMNIVORE
	
	
	Settings.species1_enabled_genes["speed"] = true if spd1_enabled.pressed else false
	Settings.species1_enabled_genes["vision"] = true if vis1_enabled.pressed else false
	Settings.species1_enabled_genes["size"] = true if siz1_enabled.pressed else false
	
	# Species 2 genes
	
	if typeof(str2var(init_nrg_val2.text)) == TYPE_REAL or typeof(str2var(init_nrg_val2.text)) == TYPE_INT:
		Settings.init_energy2 = str2var(init_nrg_val2.text)
	if  typeof(str2var(init_pop_val2.text)) == TYPE_INT:
		Settings.init_population2 = str2var(init_pop_val2.text)
	if typeof(str2var(mut_val2.text)) == TYPE_REAL or typeof(str2var(mut_val2.text)) == TYPE_INT:
		Settings.species2_genes["mutation"] = str2var(mut_val2.text)
	
	if herb2.pressed:
		Settings.species2_genes["diet"] = Settings.Diets.HERBIVORE
	elif carn2.pressed:
		Settings.species2_genes["diet"] = Settings.Diets.CARNIVORE
	else:
		Settings.species2_genes["diet"] = Settings.Diets.OMNIVORE
	
	
	Settings.species2_enabled_genes["speed"] = true if spd2_enabled.pressed else false
	Settings.species2_enabled_genes["vision"] = true if vis2_enabled.pressed else false
	Settings.species2_enabled_genes["size"] = true if siz2_enabled.pressed else false
	
	get_tree().paused = false
	
	
	for c in get_tree().get_nodes_in_group("creatures"):
		c.death()
		
	chart.get_node("Chart").clear_chart()
	Settings.births1 = 0 
	Settings.births2 = 0
	Settings.deaths1 = 0
	Settings.deaths2 = 0
	chart.x = 0
	
	if spc1_enabled.pressed:
		for crt in Settings.init_population1:
			var genes = Settings.species1_genes.duplicate()
			randomize()
			
			genes["speed"] = rand_range(0.5,2)
			genes["vision"] = rand_range(2,5)
			genes["size"]  = rand_range(0.5,2)
			
			spawner.createCreatureRand(genes)
	
	if spc2_enabled.pressed:
		for crt in Settings.init_population2:
			var genes = Settings.species2_genes.duplicate()
			randomize()
			
			genes["speed"] = rand_range(0.5,2)
			genes["vision"] = rand_range(2,5)
			genes["size"]  = rand_range(0.5,2)
			
			spawner.createCreatureRand(genes)
	
	
