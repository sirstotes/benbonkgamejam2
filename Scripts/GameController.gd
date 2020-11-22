extends Spatial
onready var transition : Panel = $CanvasLayer/Transition
export var nextLevel = "res://Scenes/Title.tscn"
var itemsLeft
var itemsInTruck = []
var scene
var vibing = 6.9

signal set_time(time)

func _ready():
	$truck/Area.connect('body_entered', self, '_onItemEnteredTruck')
	$truck/Area.connect('body_exited', self, '_onItemExitedTruck')
func _process(delta):
	vibing += 0.01
	vibing = clamp(vibing, 0, 7)
	if Input.is_action_just_pressed("ui_focus_next") and vibing > 6.9:
		vibing = 3
	elif vibing < 6.9:
		emit_signal("set_time", vibing)
		if vibing > 4.99 and vibing < 5.01:
			_empty_truck()
	itemsLeft = $Objects.get_child_count()-len(itemsInTruck)
	$CanvasLayer/Control/Label.text = "THERE ARE " + String(itemsLeft) + " ITEMS REMAINING"
	if itemsLeft+len(itemsInTruck) <= 0:
		_changeScene(nextLevel)
	if scene != null:
		transition.rect_position = transition.rect_position.linear_interpolate(Vector2(0, -4), 0.1)
		if transition.rect_position.y >= -5:
			get_tree().change_scene_to(load(scene))
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
