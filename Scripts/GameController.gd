extends Spatial
onready var transition : Panel = $CanvasLayer/Transition
export var nextLevel = "res://Scenes/Title.tscn"
var itemsLeft
var itemsInTruck = []
var scene
var vibing = 6.9
var time = 0.0
export(int) var par_trips = 1
var trips = 0
var finished = false
export(float) var time_cringe = 600.0
export(float) var time_mutiplier = 0.04
var default_score = 1000.0
var trips_factor = 1.2

signal set_time(time)

func _ready():
	$truck/Area.connect('body_entered', self, '_onItemEnteredTruck')
	$truck/Area.connect('body_exited', self, '_onItemExitedTruck')
	connect('set_time', $truck, '_on_Spatial_set_time')
	$CanvasLayer/Settings/Label/RestartButton.connect('pressed', self, '_restart')
	$CanvasLayer/Settings/Label/ExitButton.connect('pressed', self, '_changeScene', ['res://Scenes/Title.tscn'])
	$CanvasLayer/Settings/Label/BackButton.connect('pressed', self, '_unpause')
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		_pause()
func _process(delta):
	if not finished and not get_tree().paused:
		time += 1*delta
	vibing += 0.01
	vibing = clamp(vibing, 0, 7)
	if vibing < 6.9:
		emit_signal("set_time", vibing)
		if vibing > 4.99 and vibing < 5.01:
			_empty_truck()
	itemsLeft = $Objects.get_child_count()-len(itemsInTruck)
	$CanvasLayer/Control/Label.text = "THERE ARE " + String(itemsLeft) + " ITEMS REMAINING"
	$CanvasLayer/Control/Label2.text = "  " + String(round(time))
	if time > time_cringe*0.75:
		$CanvasLayer/Control/Label2.add_color_override("font_color", Color(0.9, 0.9, 0))
	if time > time_cringe:
		$CanvasLayer/Control/Label2.add_color_override("font_color", Color(0.9, 0, 0))
	if itemsLeft+len(itemsInTruck) <= 0 and not finished:
		finished = true
		var score = default_score
		if time > time_cringe:
			score = score/((time-time_cringe)*time_mutiplier)
		if (trips - par_trips + 1) > 0:
			score = score/pow(trips_factor,(trips - par_trips))
		else:
			score = 1000
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$CanvasLayer/EndPanel/Label3.text = "Trucks Loaded: " + String(trips)
		$CanvasLayer/EndPanel/Label4.text = "Time Taken: "+String(int(time))
		$CanvasLayer/EndPanel/Label5.text = "Grade: "+("A" if score > 800 else ("B" if score > 600 else ("C" if score > 400 else ("D" if score > 200 else "F"))))
		$CanvasLayer/EndPanel.visible = true
		$CanvasLayer/EndPanel/Next.connect("pressed", self, "_changeScene", [nextLevel])
		$CanvasLayer/EndPanel/Quit.connect("pressed", self, "_changeScene", ["res://Scenes/Title.tscn"])
	if scene != null:
		transition.rect_position = transition.rect_position.linear_interpolate(Vector2(0, -4), 0.1)
		if transition.rect_position.y >= -5:
			get_tree().paused = false
			get_tree().change_scene(scene)
	else:
		transition.rect_position = transition.rect_position.linear_interpolate(Vector2(0, -650), 0.1)
func _changeScene(scn : String):
	scene = scn
func _restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
func _pause():
	if not finished:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$CanvasLayer/Settings.visible = true
		get_tree().paused = true
func _unpause():
	if not finished:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$CanvasLayer/Settings.visible = false
		get_tree().paused = false
func _empty_truck():
	for item in itemsInTruck:
		item.queue_free()
func _onItemEnteredTruck(object):
	if object.is_in_group("Moving"):
		itemsInTruck.append(object)
func _onItemExitedTruck(object):
	if object.is_in_group("Moving"):
		itemsInTruck.erase(object)
func _onLoadTruck():
	if vibing > 6.9:
		vibing = 3
		trips += 1

