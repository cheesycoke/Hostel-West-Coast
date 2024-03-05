extends Control
@onready var heart = $Health/MYBEATINGHEART

func _ready():
	heart.play("default")

func _process(delta):
	pass

func setHealth(val,max):
	$Health/HPBar.value = val
	$Health/HPBar.max_value = max
	$Health/HPText.text = str(val)+"/"+str(max)
	heart.speed_scale = (max/val)

func _on_health_component_h_pchanged(hpVal, maxhpVal):
	setHealth(hpVal,maxhpVal)
	
