extends Area3D
class_name Tracker
@onready var ray = $raypoint/RayCast3D
var player:Player = null
var alert:bool = false
signal pursue(target:Player)

func _ready():
	pass

func _process(delta):
	ray.global_position = $raypoint.global_position
	if player != null:
		track()

func track():
	ray.look_at(player.global_position)
	if ray.is_colliding():
		if ray.get_collider() is Player:
			alert = true

func _on_body_entered(body):
	if body is Player:
		player = body
		
