extends Spatial


func _on_Area_body_entered(body):
	self.queue_free()
