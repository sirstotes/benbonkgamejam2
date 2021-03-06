extends RigidBody

var velocity
export var frozenUntilChosen = true

onready var pickup = $"/root/Spatial/Player/Viewport/Pickup"
onready var player = $"/root/Spatial/Player"
onready var my_mesh = $"mesh"
onready var sound = $AudioStreamPlayer3D

var looking = Vector3()
var picked = false
var ready_to_pick_up = false
var distance = Vector3()
var speed = 20
var sensitivity = 0.2
var looked_at = 0

func _ready():
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered", self, "_on_body_entered")
	add_to_group("Moving")
	if frozenUntilChosen:
		sleeping = true
func _input(event):
	if event is InputEventMouseMotion:
		sound.max_db = GlobalMusic.soundVolume
		if Input.is_action_pressed("player_rotate") and picked:
			looking.y -= deg2rad(event.relative.x * sensitivity)
			if !Input.is_action_pressed("player_axis"):
				looking.x -= deg2rad(event.relative.y * sensitivity)
			else:
				looking.z -= deg2rad(event.relative.y * sensitivity)
			rotation.x = looking.x
			rotation.y = looking.y
			rotation.z = looking.z
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	looked_at = looked_at - 1
	#if looked_at > 0:
		#my_mesh.get_material_override().get_next_pass()
	if(picked):
		axis_lock_angular_x = true
		axis_lock_angular_y = true
		axis_lock_angular_z = true
		distance = player.global_transform.origin - self.global_transform.origin
		if distance.length() > 5:
			picked = false
			ready_to_pick_up = false
			player.ready_to_let_down = true
		distance = pickup.global_transform.origin - self.global_transform.origin
		linear_velocity = distance * 10
		if GlobalMusic.toggleOptions[0]:
			if !Input.is_action_pressed("player_pickup"):
				picked = false
				ready_to_pick_up = false
				player.ready_to_let_down = true
		else:
			if Input.is_action_just_pressed("player_pickup"):
				picked = false
				ready_to_pick_up = false
				player.ready_to_let_down = true
	elif ready_to_pick_up:
		picked = true
		ready_to_pick_up = false
		Input.is_action_just_pressed("player_pickup")
		angular_velocity = Vector3( 0, 0, 0 )
		player.holding = true
	else:
		axis_lock_angular_x = false
		axis_lock_angular_y = false
		axis_lock_angular_z = false
	if translation.y < -100:
		queue_free()
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
func _on_body_entered(body):
	if not sound.playing:
		sound.unit_db = linear_velocity.length()
		sound.play()
