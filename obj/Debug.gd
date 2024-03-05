extends Control

var player
@onready var debug_text = $DebugText

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
	debug_text.text = "Weapon: "+player.gun.getWeaponName()
