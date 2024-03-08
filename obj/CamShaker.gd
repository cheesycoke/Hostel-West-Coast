extends Node3D
var shaking:bool = false
var shakedur:float = 0.0
var timer:float = 0.0
@onready var cam = $Cam
var strength = 1

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shaking == true:
		shake(delta)

func startShakin(dur,blts):
	shakedur = dur
	timer = 0
	strength = blts
	shaking = true

func shake(delta):
	randomize()
	timer += delta
	position.y = randf_range(-0.05*strength,0.05*strength)
	position.z = randf_range(-0.05*strength,0.05*strength)
	if timer >= shakedur:
		shaking = false
		position.y = 0
		position.z = 0
