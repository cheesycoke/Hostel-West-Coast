extends Area3D

@export var weapon:Weapon
@onready var meshpos = $meshpos

func _ready():
	var newmesh = weapon.Model.instantiate()
	$meshpos/DBGMESH.queue_free()
	meshpos.add_child(newmesh)
	$meshpos/AnimationPlayer.play("bobspin")

func _process(delta):
	pass

func _on_body_entered(body:Player):
	body.pickupShow(weapon.Name)
	body.focusgun = self

func _on_body_exited(body:Player):
	if body.focusgun == self:
		body.pickupHide()

func getGrabbed():
	call_deferred("queue_free")
