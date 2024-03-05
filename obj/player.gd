extends CharacterBody3D

class_name Player

var mouse_sensitivity = 0.002

const SPEED = 10.0
const accel := 4.0
const decel: float = 0.8

@onready var camshaker = $CamShaker
@onready var cam = $CamShaker/Cam
@onready var gun = $GunManager
@onready var hp:Health = $Components/HealthComponent
var focusgun = null

const gravity = 200
var canpunch:bool = true
var dead:bool = false

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
	cam.rotation.x = lerp(cam.rotation.x,sign(-input_dir.x)*0.05,delta*5)
	
	if Input.is_action_just_pressed("altfire") and canpunch == true:
		punch()
	
	if Input.is_action_just_pressed("use"):
		interact()
	
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

@onready var pickup_popup = $CanvasLayer/PickupPopup

func pickupShow(gunName):
	$CanvasLayer/PickupPopup/GunName.text = gunName
	pickup_popup.visible = true

func pickupHide():
	pickup_popup.visible = false
	focusgun = null

func interact():
	if focusgun != null:
		focusgun.getGrabbed()
		gun.getWeapon(focusgun.weapon)
		return

func hurt(dmg:int=2):
	hp.changeHP(-dmg)

func punch():
	canpunch = false
	$Melee/fist/punchanim.play("punch")
	await $Melee/fist/punchanim.animation_finished
	canpunch = true
