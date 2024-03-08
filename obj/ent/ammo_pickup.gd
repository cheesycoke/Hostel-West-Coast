extends Area3D

var Large:bool = false
var largechance:int = 25
@onready var mesh = $Mesh
var willanimate:bool = false

func _ready():
	randomize()
	$jump.start(randi_range(3,50))
	mesh.rotate_y(randf_range(0,360))
	Large = rollSize()

func _process(delta):
	pass

func rollSize():
	var diceroll = randi_range(0,100)
	if diceroll <= largechance:
		return true
	else:
		return false

func _on_body_entered(body):
	if body.gun.has_method("getAmmo"):
		body.gun.getAmmo(Large)

func _on_jump_timeout():
	$Mesh/anim.play("hop")
