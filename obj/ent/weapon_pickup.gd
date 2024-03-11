extends Area3D

@export var weapon:Weapon
@export var random:bool
@onready var meshpos = $meshpos

func _ready():
	if random == true:
		weapon = GunPool.getRandomWeapon()
	while not weapon is Weapon:
		await get_tree().process_frame
	setMesh()
	$meshpos/AnimationPlayer.play("bobspin")

func _process(delta):
	pass

func setMesh():
	var newmesh = weapon.Model.instantiate()
	$meshpos/DBGMESH.queue_free()
	meshpos.add_child(newmesh)

func _on_body_entered(body:Player):
	body.pickupShow(weapon.Name)
	body.focusgun = self

func _on_body_exited(body:Player):
	if body.focusgun == self:
		body.pickupHide()

func getGrabbed():
	call_deferred("queue_free")
