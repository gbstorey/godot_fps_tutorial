extends CharacterBody3D

@export var mouse_sens = 0.35
@export var move_accel = 4
@export var max_speed = 20
@export var gravity = 40
@export var jump_impulse = 18
@onready var camera = $Camera3D

var target_velocity = Vector3.ZERO
var drag = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	drag = float(move_accel) / max_speed

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		direction += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector3.RIGHT
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	direction = direction.rotated(Vector3.UP, rotation.y)
	target_velocity.x += move_accel * direction.x - target_velocity.x * drag
	target_velocity.z += move_accel * direction.z - target_velocity.z * drag
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	velocity = target_velocity
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
