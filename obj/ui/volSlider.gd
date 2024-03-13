extends HSlider
@export var slidername:String

func _ready():
	$Label.text = slidername
