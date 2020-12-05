extends CheckBox
export var optionNum = 0
func _ready():
	pressed = GlobalMusic.toggleOptions[optionNum]
func _process(delta):
	GlobalMusic.toggleOptions[optionNum] = pressed
