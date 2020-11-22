extends KinematicBody

export(float) var walk_accel = 10000
export(float) var max_walk_speed = 1
export(float) var max_run_speed = 2
export(float) var jump_speed = 0
export(float) var gravity = -50
export(float) var sensitivity = 0.2
export(float) var friction = 100
export(float) var uncrouch_height = 1
export(float) var crouch_height = 0.0
export(NodePath) var crosshairPath

var velocity = Vector3()
var looking = Vector3()
var holding = false
var largeCrosshair = false
var ready_to_let_down = false
onready var viewport = $Viewport
onready var pickup_node = $Viewport/Pickup
onready var collision = $CollisionShape
var crosshair : TextureRect

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair = get_node_or_null(crosshairPath)
	
func _input(event):
	if event is InputEventMouseMotion and !Input.is_action_pressed("player_rotate"):
		looking.y -= deg2rad(event.relative.x * sensitivity)
		looking.x -= deg2rad(event.relative.y * sensitivity)
		looking.x = clamp(looking.x, -PI/3, PI/3)
		viewport.rotation.y = looking.y
		viewport.rotation.x = looking.x
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("player_pickup"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _process(delta):
	if crosshair != null:
		if largeCrosshair:
			if crosshair.rect_size.x < 10:
				crosshair.rect_size.x += delta*50
				crosshair.rect_size.y = crosshair.rect_size.x
		else:
			if crosshair.rect_size.x > 5:
				crosshair.rect_size.x -= delta*50
				crosshair.rect_size.y = crosshair.rect_size.x
func _physics_process(delta):
	velocity.y += gravity * delta
	if !holding:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(global_transform.origin, pickup_node.global_transform.origin, [self])
		if len(result) > 0 and result['collider'].is_in_group("Moving"):
			largeCrosshair = true
			if Input.is_action_just_pressed("player_pickup"):
				result['collider'].ready_to_pick_up = true
		else:
			largeCrosshair = false
	Input.is_action_just_pressed("player_pickup")
	var capsule = collision.get_shape()
	if Input.is_action_pressed("player_crouch"):
		capsule.height = crouch_height
	else:
		capsule.height = uncrouch_height
	collision.set_shape(capsule)
	if ready_to_let_down:
		holding = false
		ready_to_let_down = false
	if velocity.x > friction:
		velocity.x -= friction
	elif velocity.x < -friction:
		velocity.x += friction
	else:
		velocity.x = 0

	if velocity.z > friction:
		velocity.z -= friction
	elif velocity.z < -friction:
		velocity.z += friction
	else:
		velocity.z = 0
	var forward = Input.is_action_pressed("player_forward")
	var backward = Input.is_action_pressed("player_backward")
	var left = Input.is_action_pressed("player_left")
	var right = Input.is_action_pressed("player_right")
	var jump = Input.is_action_just_pressed("player_jump")
	var run = Input.is_action_pressed("player_run")
	if is_on_floor() and jump:
		velocity.y = jump_speed
	var walkvector = Vector2()
	walkvector.x += velocity.x
	walkvector.y -= velocity.z
	if forward:
		walkvector += Vector2(walk_accel * delta, 0).rotated(viewport.rotation.y + PI/2)
	if backward:
		walkvector += Vector2(-walk_accel * delta, 0).rotated(viewport.rotation.y + PI/2)
	if left:
		walkvector += Vector2(0, walk_accel * delta).rotated(viewport.rotation.y + PI/2)
	if right:
		walkvector += Vector2(0, -walk_accel * delta).rotated(viewport.rotation.y + PI/2)
	if run:
		walkvector = walkvector.clamped(max_run_speed)
	else:
		walkvector = walkvector.clamped(max_walk_speed)
	velocity = Vector3(walkvector.x, velocity.y, -walkvector.y)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), false, 4, 0.785398, false)
