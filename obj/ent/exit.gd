extends Node3D
class_name Exit
const DOOR = preload("res://obj/ent/door.tscn")
var room:CSGCombiner3D
@onready var fullroom = get_parent()
func _ready():
	await get_tree().process_frame
	room = fullroom.csg
	spawndoor()

func _process(delta):
	pass

func spawndoor():
	var newdoor = DOOR.instantiate()
	room.add_child(newdoor)
	newdoor.opened.connect(dooropened)
	newdoor.global_transform = global_transform
	newdoor.position += Vector3(0.5,1.5,0).rotated(Vector3.UP,rotation.y)

func dooropened():
	makeNewroom()

func makeNewroom():
	GameLogic.addRoom(global_position,global_rotation_degrees.y-90)
	
