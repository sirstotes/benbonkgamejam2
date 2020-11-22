extends MeshInstance

onready var time = self.get_surface_material(0).get_shader_param('time')

func _ready():
	self.get_surface_material(0).set_shader_param('time', 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_truck_set_time(time):
	self.get_surface_material(0).set_shader_param('time', time)
