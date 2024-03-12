extends Node3D
@onready var gridmap = $GridMap
@onready var dunmesh = $DunMesh
@onready var player = get_tree().get_first_node_in_group("player")
