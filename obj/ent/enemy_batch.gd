extends Node3D
var ENEMY_SPAWNER = preload("res://obj/ent/enemy_spawner.tscn")
var ENEMYCHOICE = preload("res://obj/enemy/bellbastard.tscn")
var spacing:int = 2
var roomscale:int = 4
var posList:PackedVector3Array=[
	Vector3(1.5,0,1.5),
	Vector3(1.5,0,-1.5),
	Vector3(-1.5,0,1.5),
	Vector3(-1.5,0,-1.5),
	Vector3(0,0,1.5),
	Vector3(0,0,-1.5),
]
func _ready():
	await get_tree().create_timer(0.4).timeout
	$Area3D.queue_free()

func _process(delta):
	pass

func playerClean():
	pass
	#var player = get_tree().get_first_node_in_group("player")
	#if global_position.distance_to(player.global_position) <= 10:
		#queue_free()

func spawnEnemies(roomsize:Vector2):
	var enemycount
	if roomsize.x < roomsize.y:
		enemycount = roomsize.x
	else:
		enemycount = roomsize.y
	
	
	
	for i in posList:
		if i == Vector3(0,0,1.5):
			var roll = randi_range(0,5)
			if roll <= 2:
				break
		spawnOne(i*(enemycount/2))
	playerClean()
	
func spawnOne(pos:=Vector3(0,0,0)):
	var newEnemy = ENEMY_SPAWNER.instantiate()
	newEnemy.enemy = ENEMYCHOICE 
	add_child(newEnemy)
	newEnemy.position = pos
	newEnemy.spawn()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
