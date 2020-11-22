extends Spatial
onready var transition : Panel = $CanvasLayer/Transition
var itemsLeft
var itemsInTruck = []
var scene
func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		_empty_truck()
	itemsLeft = $Objects.get_child_count()-len(itemsInTruck)
	$CanvasLayer/Control/Label.text = "THERE ARE " + String(itemsLeft) + " ITEMS REMAINING"
	if itemsLeft+len(itemsInTruck) <= 0:
		_changeScene("res://Scenes/Title.tscn")
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
