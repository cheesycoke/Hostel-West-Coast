@tool
extends Node3D
@onready var spawner = $".."

#func _ready():
	#if !Engine.is_editor_hint():
		#queue_free()

#func _process(delta):
	#if spawner.enemy != null:
		#$Label3D.text = spawner.enemy.enemyname
