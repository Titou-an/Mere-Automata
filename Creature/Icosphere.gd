extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func colorChange(arr):
	var newmat = SpatialMaterial.new()
	newmat.albedo_color = Color(arr[0], arr[1], arr[2])
	self.material_override = newmat
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
