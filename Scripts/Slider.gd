extends HSlider
export var music = true
func _ready():
	if music:
		value = GlobalMusic.get_node("Track1").volume_db
	else:
		pass#value = GlobalMusic.get_node("Track1").volume_db
func _process(delta):
	if music:
		GlobalMusic.get_node("Track1").set_volume_db(value)
	else:
		GlobalMusic.soundVolume = value
