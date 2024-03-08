extends Area3D
var playerpos:Vector3 = Vector3(0,0,0)
func hit(pos):
	playerpos = pos
	monitoring = true
	await get_tree().create_timer(0.08).timeout
	monitoring = false
func _on_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(4,playerpos)
