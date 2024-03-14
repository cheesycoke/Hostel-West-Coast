extends Area3D

var Large:bool = false
var largechance:int = 25
@onready var mesh = $ScaleLarge/Mesh
var willanimate:bool = false

func _ready():
	randomize()
	$jump.start(randi_range(3,50))
	mesh.rotate_y(randf_range(0,360))
	Large = rollSize()
	if Large == true:
		$ScaleLarge.scale = Vector3(1.5,1.25,1.5)

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
		body.ammoGain()
		body.gun.getAmmo(Large)
		call_deferred("queue_free")

func _on_jump_timeout():
	$ScaleLarge/Mesh/anim.play("hop")
