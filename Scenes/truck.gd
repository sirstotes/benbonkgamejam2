extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal set_time(time)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Spatial_set_time(time):
	emit_signal("set_time", time)
