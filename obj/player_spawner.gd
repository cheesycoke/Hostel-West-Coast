extends Node3D
class_name PlayerSpawner
const PLAYER = preload("res://obj/player.tscn")
func _ready():
	GameLogic.spawnSpot = self
	spawn()
func spawn():
	if GameLogic.grabChild() != null:
		GameLogic.grabChild().reparent(self)
		get_child(0).global_position = global_position
		return
	print("playerspawner, making my own player!")
	var newplayer = PLAYER.instantiate()
	add_child(newplayer)
	get_child(0).global_position = global_position
