extends RayCast3D

var landed:bool = false
var dmg:int = 2

func _ready():
	await get_tree().create_timer(0.06).timeout
	queue_free()

func _process(delta):
	if is_colliding() and landed == false:
		landed = true
		if get_collider().has_method("hurt"):
			get_collider().hurt(dmg,get_collision_point())
