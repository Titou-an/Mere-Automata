extends Control

onready var  player_ui = get_node("../../PlayerFreeCam/UI")

onready var genes = $CenterContainer/SpeciesControl/Panel/SpeciesSettings/HBoxContainer/Genes

onready var creature_id = genes.get_node("CretureID")

onready var genes_inputs = genes.get_node("Genes/Inputs")

onready var species_btn1 = genes_inputs.get_node("Species/Species1")
onready var species_btn2 = genes_inputs.get_node("Species/Species2")

onready var energy_val = genes_inputs.get_node("Energy")

onready var speed_val = genes_inputs.get_node("Speed")

onready var vis_radius_val = genes_inputs.get_node("Vision")

onready var size_val = genes_inputs.get_node("Size")

onready var mutation_val = genes_inputs.get_node("Mutation")

onready var diet_herb = genes.get_node("Diet/Herb")
onready var diet_carn = genes.get_node("Diet/Carn")
onready var diet_omni = genes.get_node("Diet/Omni")

var targ

func update_info(target):
	
	targ = target
	
	creature_id.text = "Creature id#" + String(target.get_instance_id())
	
	energy_val.text = var2str(target.energy)
	
	speed_val.text = var2str(target.genes["speed"])
	
	vis_radius_val.text = var2str(target.genes["vis_radius"])
	
	size_val.text = var2str(target.genes["size"])
	
	mutation_val.text = var2str(target.genes["mutation"])
	
	if !target.genes["species"]:
		species_btn1.pressed = true
	else:
		species_btn2.pressed = true
	
	if target.genes["diet"] == 0:
		diet_herb.pressed = true
	elif target.genes["diet"] == 1:
		diet_carn.pressed = true
	else:
		diet_omni.pressed = true

func apply_changes(target):
	
	if typeof(str2var(energy_val.text)) == TYPE_REAL or typeof(str2var(energy_val.text)) == TYPE_INT:
		target.energy = str2var(energy_val.text)
	if typeof(str2var(speed_val.text)) == TYPE_REAL or typeof(str2var(speed_val.text)) == TYPE_INT:
		target.genes["speed"] = str2var(speed_val.text)
	if typeof(str2var(vis_radius_val.text)) == TYPE_REAL or typeof(str2var(vis_radius_val.text)) == TYPE_INT:
		target.genes["vis_radius"] = str2var(vis_radius_val.text)
	if typeof(str2var(size_val.text)) == TYPE_REAL or typeof(str2var(size_val.text)) == TYPE_INT:
		target.genes["size"] = str2var(size_val.text)
	if typeof(str2var(mutation_val.text)) == TYPE_REAL or typeof(str2var(mutation_val.text)) == TYPE_INT:
		target.genes["mutation"] = str2var(mutation_val.text)
	
	if species_btn1.pressed:
		target.genes["species"] = 0
	if species_btn2.pressed:
		target.genes["species"] = 1
	
	if diet_herb.pressed:
		target.genes["diet"] = 0
	if diet_carn.pressed:
		target.genes["diet"] = 1
	if diet_omni.pressed:
		target.genes["diet"] = 2
	
	target.update_val()

func _on_Back_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_Kill_pressed():
	
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	targ.death()


func _on_Apply_pressed():
	player_ui.visible = !player_ui.visible
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	apply_changes(targ)
