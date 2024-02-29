extends CharacterBody3D

var mouse_sensitivity = 0.02

const SPEED = 10.0
const accel := 4.0
const decel: float = 0.8

@onready var cam = $Cam

var gravity = 200

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("back", "fwd", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, decel)
		velocity.z = move_toward(velocity.z, 0, decel)
	cam.rotation.z = lerp(cam.rotation.z,sign(-input_dir.y)*0.1,delta*5)
	
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
