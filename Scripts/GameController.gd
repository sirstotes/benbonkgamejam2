extends Spatial
onready var transition : Panel = $CanvasLayer/Transition
export var nextLevel = "res://Scenes/Title.tscn"
var itemsLeft
var itemsInTruck = []
var scene
var vibing = 6.9
var time = 0.0
var trips = 0
var finished = false
export(float) var time_cringe = 60.0
export(float) var time_mutiplier = 0.5
var default_score = 1000.0

signal set_time(time)

func _ready():
	$truck/Area.connect('body_entered', self, '_onItemEnteredTruck')
	$truck/Area.connect('body_exited', self, '_onItemExitedTruck')
	connect('set_time', $truck, '_on_Spatial_set_time')
func _process(delta):
	if not finished:
		time += 1*delta
	vibing += 0.01
	vibing = clamp(vibing, 0, 7)
	if Input.is_action_just_pressed("ui_focus_next") and vibing > 6.9:
		vibing = 3
		trips += 1
	elif vibing < 6.9:
		emit_signal("set_time", vibing)
		if vibing > 4.99 and vibing < 5.01:
			_empty_truck()
	itemsLeft = $Objects.get_child_count()-len(itemsInTruck)
	$CanvasLayer/Control/Label.text = "THERE ARE " + String(itemsLeft) + " ITEMS REMAINING"
	if itemsLeft+len(itemsInTruck) <= 0 and not finished:
		finished = true
		var score = default_score
		if time > time_cringe:
			score = score/((time-time_cringe)*time_mutiplier)
		score = score/trips
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$CanvasLayer/EndPanel/Label3.text = "Trucks Loaded: "+String(trips)
		$CanvasLayer/EndPanel/Label4.text = "Time Taken: "+String(int(time))+" Seconds"
		$CanvasLayer/EndPanel/Label5.text = "Grade: "+("A" if score > 60 else ("B" if score > 30 else ("C" if score > 15 else ("D" if score > 5 else "F"))))
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
func _empty_truck():
	for item in itemsInTruck:
		item.queue_free()
func _onItemEnteredTruck(object):
	if object.is_in_group("Moving"):
		itemsInTruck.append(object)
func _onItemExitedTruck(object):
	if object.is_in_group("Moving"):
		itemsInTruck.erase(object)
