extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.06).timeout
	queue_free()

func _process(delta):
	pass
