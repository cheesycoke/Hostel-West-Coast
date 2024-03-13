#@tool
extends GridMap
#thank u quwatz_ for coming in clutch with the procgen tutorial
@export var start:bool = false : set = set_start
@onready var gridmap:GridMap = $"."
@onready var generator = $".."
var player:Player
var playerSpawner:PlayerSpawner
const ROOM_LIGHTS = preload("res://obj/fx/room_lights.tscn")
const ENEMY_BATCH = preload("res://obj/ent/enemy_batch.tscn")

func _ready():
	player = generator.player
	playerSpawner = get_tree().get_first_node_in_group("playerSpawner")
	if !Engine.is_editor_hint():
		call_deferred("newFloor")
		
func newFloor():
	if get_tree().get_nodes_in_group("levelEnts").size() >= 0:
		for i in get_tree().get_nodes_in_group("levelEnts"):
			i.queue_free()
	RoomNumber = randi_range(5,8)
	RoomNumberAdjusted = RoomNumber
	generate()
	await get_tree().create_timer(0.1).timeout
	gridmap.visible = false

func set_start(val:bool):
	if Engine.is_editor_hint():
		generate()

@export_range(0,1) var survivalChance:float = 0.25
@export var border_size:int=20 : set = set_border_size
func set_border_size(val:int)->void:
	border_size=val
	if Engine.is_editor_hint():
		visualize_border()

@export var RoomNumber:int=4
@export var MinRoomSize:int=2
@export var MaxRoomSize:int=4
@export var RoomMargin:int=1
@export var MaxTries:int=15
var RoomNumberAdjusted:int=4
#im mixing cases fuck you
var roomTiles:Array[PackedVector3Array] = []
var roomPositions:PackedVector3Array = []
var roomSizes:PackedVector2Array=[]

func visualize_border():
	gridmap.clear()
	for i in range(-1,border_size+1):
		gridmap.set_cell_item(Vector3i(i,0,-1),3)
		gridmap.set_cell_item(Vector3i(i,0,border_size),3)
		gridmap.set_cell_item(Vector3i(border_size,0,i),3)
		gridmap.set_cell_item(Vector3i(-1,0,i),3)

func generate():
	roomTiles.clear()
	roomPositions.clear()
	roomSizes.clear()
	visualize_border()
	for i in RoomNumber:
		make_room(MaxTries)
	
	var rpv2:PackedVector2Array=[]
	var delGraph:AStar2D=AStar2D.new()
	var mstGraph:AStar2D=AStar2D.new()
	
	for p in roomPositions:
		rpv2.append(Vector2(p.x,p.z))
		delGraph.add_point(delGraph.get_available_point_id(),Vector2(p.x,p.z))
		mstGraph.add_point(mstGraph.get_available_point_id(),Vector2(p.x,p.z))
	
	var delaunay:Array=Array(Geometry2D.triangulate_delaunay(rpv2))
	
	for i in delaunay.size()/3:
		var p1:int=delaunay.pop_front()
		var p2:int=delaunay.pop_front()
		var p3:int=delaunay.pop_front()
		delGraph.connect_points(p1,p2)
		delGraph.connect_points(p2,p3)
		delGraph.connect_points(p1,p3)
		
	var visitedPoints:PackedInt32Array=[]
	visitedPoints.append(randi()%roomPositions.size())
	while visitedPoints.size() != mstGraph.get_point_count():
		var possibleConnections:Array[PackedInt32Array]=[]
		for vp in visitedPoints:
			for c in delGraph.get_point_connections(vp):
				if !visitedPoints.has(c):
					var con:PackedInt32Array=[vp,c]
					possibleConnections.append(con)
		if possibleConnections.size() == 0:
			get_tree().reload_current_scene()
		var connection:PackedInt32Array=possibleConnections.pick_random()
		for pc in possibleConnections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) <\
			rpv2[connection[0]].distance_squared_to(rpv2[connection[1]]):
				connection = pc
		visitedPoints.append(connection[1])
		mstGraph.connect_points(connection[0],connection[1])
		delGraph.disconnect_points(connection[0],connection[1])
	
	var hallwayGraph:AStar2D=mstGraph
	for p in delGraph.get_point_ids():
		for c in delGraph.get_point_connections(p):
			if c>p:
				var kill:float=randf()
				if survivalChance > kill:
					hallwayGraph.connect_points(p,c)
	
	create_hallways(hallwayGraph)
	roomsMade()

func create_hallways(hallwayGraph:AStar2D):
	var hallways:Array[PackedVector3Array]=[]
	for p in hallwayGraph.get_point_ids():
		for c in hallwayGraph.get_point_connections(p):
			if c>p:
				var roomFrom:PackedVector3Array=roomTiles[p]
				var roomTo:PackedVector3Array=roomTiles[c]
				var tileFrom:Vector3=roomFrom[0]
				var tileTo:Vector3=roomTo[0]
				for t in roomFrom:
					if t.distance_squared_to(roomPositions[c])<\
					tileFrom.distance_squared_to(roomPositions[c]):
						tileFrom = t
				for t in roomTo:
					if t.distance_squared_to(roomPositions[p])<\
					tileTo.distance_squared_to(roomPositions[p]):
						tileTo = t
				var hallway:PackedVector3Array=[tileFrom,tileTo]
				hallways.append(hallway)
				gridmap.set_cell_item(tileFrom,2)
				gridmap.set_cell_item(tileTo,2)
	
	var astar:AStarGrid2D=AStarGrid2D.new()
	astar.size=Vector2i.ONE*border_size
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	for t in gridmap.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x,t.z))
	
	for h in hallways:
		var posFrom:Vector2i=Vector2i(h[0].x,h[0].z)
		var posTo:Vector2i=Vector2i(h[1].x,h[1].z)
		var hall:PackedVector2Array=astar.get_point_path(posFrom,posTo)
		
		for t in hall:
			var pos:Vector3i=Vector3i(t.x,0,t.y)
			if gridmap.get_cell_item(pos)<0:
				gridmap.set_cell_item(pos,1)

#you're copying and pasting. how embarrassing!
#for right now let's stick to just copying and pasting.
#legit the idea of level layouts being based on hotels is totally out the window for the jam version of this game.
#later on, i can look back at this and get a better understanding of it so i can adjust the generation behavior as i desire

func make_room(rec):
	if !rec>0:
		RoomNumberAdjusted -= 1
		#if roomPositions.size() == RoomNumberAdjusted:
			#roomsMade()
		return
	var width : int = randi_range(MinRoomSize,MaxRoomSize)
	var height : int = randi_range(MinRoomSize,MaxRoomSize)
	
	var startpos : Vector3i
	startpos.x = randi() % (border_size-width+1)
	startpos.z = randi() % (border_size-height+1)
	
	for r in range(-RoomMargin,height+RoomMargin):
		for c in range(-RoomMargin,width+RoomMargin):
			var pos : Vector3i = startpos + Vector3i(c,0,r)
			if gridmap.get_cell_item(pos) == 0:
				make_room(rec-1)
				return
	
	var room:PackedVector3Array=[]
	for r in height:
		for c in width:
			var pos : Vector3i = startpos + Vector3i(c,0,r)
			gridmap.set_cell_item(pos,0)
			room.append(pos)
	roomTiles.append(room)
	var avgX:float = startpos.x + (float(width)/2)
	var avgZ:float = startpos.z + (float(height)/2)
	var pos:Vector3 = Vector3(avgX,0,avgZ)
	roomPositions.append(pos)
	roomSizes.append(Vector2(width,height))
	#if roomPositions.size() == RoomNumberAdjusted:
		#roomsMade()

func roomsMade():
	var playerSpawnRoom = roomPositions[randi()%roomPositions.size()]
	playerSpawner.position = playerSpawnRoom*generator.scale.x
	playerSpawner.position.y=2.33
	for i in roomPositions.size():
		lightRooms(i)
	for i in roomPositions.size():
		call_deferred("makeSpawners",i)
	call_deferred("makeElevator")

const EVILATOR = preload("res://obj/ent/evilator.tscn")
func makeElevator():
	var newelevator = EVILATOR.instantiate()
	var exitroomnum = randi()%roomPositions.size()
	var exitroompos = roomPositions[exitroomnum]*generator.scale.x
	get_tree().get_current_scene().add_child(newelevator)
	await get_tree().process_frame
	newelevator.position = exitroompos
	newelevator.position.z = exitroompos.z+roomSizes[exitroomnum].y

const CEILING_LIGHT = preload("res://obj/fx/ceiling_light.tscn")
func lightRooms(num):
	var newlight = CEILING_LIGHT.instantiate()
	await get_tree().process_frame
	get_tree().get_current_scene().add_child(newlight)
	await get_tree().process_frame
	newlight.global_position = roomPositions[num]*4
	newlight.global_position.y = 14
	#var roomlights = ROOM_LIGHTS.instantiate()
	#add_child(roomlights)
	#roomlights.position = roomPositions[num]
	#roomlights.createLights(roomSizes[num].x,roomSizes[num].y)
const ENEMY_SPAWNER = preload("res://obj/ent/enemy_batch.tscn")
func makeSpawners(num):
	var newbatch = ENEMY_SPAWNER.instantiate()
	get_tree().get_current_scene().add_child(newbatch)
	newbatch.global_position = roomPositions[num]*4
	newbatch.global_position.y = 2.5
	newbatch.spawnEnemies(roomSizes[num])
