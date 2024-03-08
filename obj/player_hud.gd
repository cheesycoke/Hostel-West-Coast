extends Control
@onready var heart = $Health/MYBEATINGHEART
@onready var seer = $BottomLeft/Seer
@onready var ammo = $BottomLeft/Thought/Ammo
var curammo:int = 0

func _ready():
	heart.play("default")
	seer.play("default")
	$BottomLeft/Thought.play("default")

func _process(delta):
	ammo.text = str(curammo)

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
