extends Node
class_name Health
@export var maxhp:float = 10
var hp:float = 10
var dead:bool = false

signal died
signal HPchanged(hpVal,maxhpVal)

func _ready():
	hp = maxhp
	emit_signal("HPchanged",hp,maxhp)

func _process(delta):
	if hp <= 0 and dead == false:
		dead = true
		emit_signal("died")

func changeHP(val):
	hp += val
	hp = clamp(hp,0,maxhp)
	emit_signal("HPchanged",hp,maxhp)
func setHP(val):
	hp = val
	hp = clamp(hp,0,maxhp)
	emit_signal("HPchanged",hp,maxhp)
