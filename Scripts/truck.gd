extends MeshInstance
signal set_time(time)
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
func _on_Spatial_set_time(time):
	emit_signal("set_time", time)
