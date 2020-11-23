extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var seeing = false
var just_saw = false
var text = ''


var hints = ['The window looks wider than the door',
			"I'm feeling pretty tired, but ill take the truck if you click on me",
			"I'm feeling pretty tired, but ill take the truck if you click on me",
			"We can drive the truck mutiple times, but I don't want to waste gas"]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('Dylan')

func _process(delta):
	if seeing:
		if !just_saw:
			$'../../../CanvasLayer/Control/Label3'.visible = true
			$'../../../CanvasLayer/Control/Label3'.text = hints[randi() % hints.size()]
			just_saw = true
	else:
		$'../../../CanvasLayer/Control/Label3'.visible = false
		just_saw = false
	seeing = false
	
