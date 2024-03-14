extends RigidBody3D
#
#func _ready():
	#apply_central_impulse(Vector3(cos(global_rotation.y),0,sin(global_rotation.y))*20)
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		$AudioStreamPlayer3D.play()
		body.hurt(40,global_position)

func _on_timer_timeout():
	GameLogic.bleed(global_position)
	call_deferred("queue_free")
