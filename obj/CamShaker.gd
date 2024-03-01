extends Node3D
var shaking:bool = false
var shakedur:float = 0.0
var timer:float = 0.0
@onready var cam = $Cam

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shaking == true:
		shake(delta)

func startShakin(dur):
	shakedur = dur
	timer = 0
	shaking = true

func shake(delta):
	randomize()
	timer += delta
	position.y = randf_range(-0.1,0.1)
	position.z = randf_range(-0.1,0.1)
	if timer >= shakedur:
		shaking = false
		position.y = 0
		position.z = 0
