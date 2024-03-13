#@tool
extends Node3D

@export var GridMapPath:NodePath
@onready var gridmap:GridMap=get_node(GridMapPath)
var duncellScene:PackedScene=preload("res://obj/sys/roomGen/room_walls.tscn")

@export var start:bool=false:set=set_start

func _ready():
	create_dungeon()

func set_start(val:bool)->void:
	if Engine.is_editor_hint():
		create_dungeon()
	
var directions:Dictionary={
	"up":Vector3i.FORWARD,"down":Vector3i.BACK,
	"left":Vector3i.LEFT,"right":Vector3i.RIGHT
}

func handle_none(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_00(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_01(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_02(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_10(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_11(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_12(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_20(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_21(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
func handle_22(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)

func create_dungeon():
	await get_tree().create_timer(0.1).timeout
	for c in get_children():
		remove_child(c)
		c.queue_free()
	for cell in gridmap.get_used_cells():
		var cell_index:int=gridmap.get_cell_item(cell)
		if cell_index<=2\
		&& cell_index>=0:
			var duncell:Node3D=duncellScene.instantiate()
			duncell.position=Vector3(cell)+Vector3(0.5,0.5,0.5)
			add_child(duncell)
			for i in 4:
				var cellN = cell+directions.values()[i]
				var cellN_index:int=gridmap.get_cell_item(cellN)
				if cellN_index == -1\
				|| cellN_index == 3:
					handle_none(duncell,directions.keys()[i])
				else:
					var key:String = str(cell_index)+str(cellN_index)
					call("handle_"+key,duncell,directions.keys()[i])
