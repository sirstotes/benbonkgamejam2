extends RigidBody


var velocity;

onready var pickup = $"../Player/Viewport/Pickup"

var picked = false
var ready_to_pick_up = false
var distance = Vector3()
var speed = 20
var sensitivity = 0.2

func _ready():
	add_to_group("Moving")

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("player_rotate") and picked:
		var looking = Vector3()
		looking.y -= deg2rad(event.relative.x * sensitivity)
		looking.x -= deg2rad(event.relative.y * sensitivity)
		rotate_x(looking.x)
		rotate_y(looking.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(picked):
		axis_lock_angular_x = true
		axis_lock_angular_y = true
		axis_lock_angular_z = true
		distance = pickup.global_transform.origin - self.global_transform.origin
		linear_velocity = distance * 10
		if Input.is_action_just_pressed("player_pickup"):
			picked = false
			ready_to_pick_up = false
	elif ready_to_pick_up:
		picked = true
		ready_to_pick_up = false
		Input.is_action_just_pressed("player_pickup")
		angular_velocity = Vector3( 0, 0, 0 )
	else:
		axis_lock_angular_x = false
		axis_lock_angular_y = false
		axis_lock_angular_z = false
	#self.translation = pickup.global_transform.origin
	
func find_closest(input):
	var negpit = abs(input - -PI/2)
	var pi = abs(input - -PI)
	var pit = abs(input - PI/2)
	input = abs(input)
	if input < negpit and input < pi and input < pit:
		return input
	elif pit < pi and pit < negpit and pit < input:
		return pit
	elif pi < pit and pi < negpit and pi < input:
		return pi
	elif negpit < pit and negpit < pi and negpit < input:
		return negpit
