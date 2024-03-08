extends Node3D
@export var enemy:PackedScene
func _ready():
	spawn()
func spawn():
	var newenemy = enemy.instantiate()
	add_child(newenemy)
