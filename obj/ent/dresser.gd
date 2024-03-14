extends StaticBody3D
var broken:bool=false

func hurt(dmg,pos):
	if broken == false:
		getbroken()

func getbroken():
	$CollisionShape3D.queue_free()
	GameLogic.shatterWood(global_position)
	
	broken = true
	$AudioStreamPlayer.play(0.1)
	$dresser.visible = false
	var roll = randi_range(0,10)
	if roll < 5:
		GameLogic.dropAmmo(global_position)
	elif roll < 8:
		GameLogic.dropHealth(global_position)
	else:
		GameLogic.dropWeapon(global_position)
	
func _on_audio_stream_player_finished():
	call_deferred("queue_free")
