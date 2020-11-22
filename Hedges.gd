tool
extends Spatial
func _ready():
	randomize()
	for hedge in get_children():
		hedge.rotation_degrees.y = 0
		if hedge is MeshInstance:
			hedge.rotate_y(randf()*0.5)
