extends Spatial
onready var panel : Panel = $CanvasLayer/Control
onready var transition : Panel = $CanvasLayer/Transition
var part = 0
var scene
var timePassed = 0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	transition.visible = true
func _process(delta):
	OS.window_fullscreen = GlobalMusic.toggleOptions[1]
	timePassed += delta
	if timePassed > 5:
		var wid = panel.rect_size.x
		panel.rect_position = panel.rect_position.linear_interpolate(Vector2(0 if part == 0 else -get_viewport().size.x/2-wid, 0), 2*delta)
		$CanvasLayer/LevelSelect.rect_position = $CanvasLayer/LevelSelect.rect_position.linear_interpolate(Vector2(0 if part == 1 else -get_viewport().size.x/2-wid, 0), 2*delta)
		$CanvasLayer/Settings.rect_position = $CanvasLayer/Settings.rect_position.linear_interpolate(Vector2(0 if part == 2 else -get_viewport().size.x/2-wid, 0), 2*delta)
		$CanvasLayer/Credits.rect_position = $CanvasLayer/Credits.rect_position.linear_interpolate(Vector2(0 if part == 3 else -get_viewport().size.x/2-wid, 0), 2*delta)
	if scene != null:
		transition.rect_position = transition.rect_position.linear_interpolate(Vector2(0, -4), 1*delta)
		if transition.rect_position.y >= -5:
			get_tree().change_scene_to(load(scene))
	else:
		transition.rect_position = transition.rect_position.linear_interpolate(Vector2(0, -get_viewport().size.y-615), 2*delta)
func _changeScene(scn : String):
	scene = scn
func _main():
	part = 0
func _levelSelect():
	part = 1
func _settings():
	part = 2
func _credits():
	part = 3
func _quit():
	get_tree().quit()
