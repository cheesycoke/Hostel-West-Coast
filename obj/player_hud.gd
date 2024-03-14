extends Control
@onready var heart = $Health/MYBEATINGHEART
@onready var seer = $BottomLeft/Seer
@onready var ammo = $BottomLeft/Thought/Ammo
var curammo:int = 0
var shells:int = 0
var bullets:int= 0

func _ready():
	heart.play("default")
	seer.play("default")
	$BottomLeft/Thought.play("default")

func _process(delta):
	$TopRight/NumEnemies.text = str(get_tree().get_nodes_in_group("enemy").size())
	$TopRight/Floor.text = "FLOOR -"+str(GameLogic.curfloor)
	if get_tree().get_nodes_in_group("enemy").size() == 0:
		GameLogic.levelClear = true
	$TopRight/EXITOPEN.visible = GameLogic.levelClear
	ammo.text = str(curammo)
	$BottomLeft/AmmoList/curbullets.label.text = str(bullets)
	$BottomLeft/AmmoList/curshells.label.text = str(shells)

func setHealth(val,max):
	$Health/HPBar.value = val
	$Health/HPBar.max_value = max
	$Health/HPText.text = str(val)+"/"+str(max)
	heart.speed_scale = (max/val)

func _on_health_component_h_pchanged(hpVal, maxhpVal):
	setHealth(hpVal,maxhpVal)
	
func animateSeer(animName:String="thumb"):
	match animName:
		"thumb":
			seer.thumbsup()
		"smile":
			seer.allsmiles()

func animateAmmo(type):
	match type:
		"Bullets":
			$BottomLeft/AmmoList/curbullets.gotten()
		"Shells":
			$BottomLeft/AmmoList/curshells.gotten()
