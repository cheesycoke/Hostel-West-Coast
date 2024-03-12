extends Node3D
class_name EnemySpawner
@export var enemy:PackedScene
func _ready():
	await get_tree().create_timer(0.1).timeout
	$Area3D.queue_free()
func spawn():
	var newenemy = enemy.instantiate()
	newenemy.spawnerpos = global_position
	add_child(newenemy)
	newenemy.global_position = global_position

func _on_area_3d_body_entered(body):
	if !body.is_in_group("enemy"):
		queue_free()
