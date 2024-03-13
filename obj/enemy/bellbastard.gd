extends Enemy
@onready var smp = $StateMachinePlayer
@onready var smackbox = $smackbox
var moveDir = Vector2(0,0)
const spd = 4
@onready var recover:Timer = $Recover
@onready var model = $mesh/model

func _ready():
	$smackbox/Timer.start(randf_range(0.5,3))
	super()

func _physics_process(delta):
	super(delta)
	
func hurt(dmg,pushawaypos):
	super(dmg,pushawaypos)
	smp.set_trigger("hurt")
	velocity = Vector3((global_position.x-pushawaypos.x)*(dmg*2),0,(global_position.z-pushawaypos.z)*(dmg*2))
	recover.start(0.4)

func _on_state_machine_player_updated(state, delta):
	pass
	match state:
		"Idle":
			if tracker:
				if tracker.player and tracker.alert == true:
					if global_position.distance_to(tracker.player.global_position) >= 1:
						model.run()
						look_at(tracker.player.global_position)
						moveDir = Vector2(global_position.x,global_position.z).direction_to(Vector2(tracker.player.global_position.x,tracker.player.global_position.z))
						velocity = Vector3(moveDir.x*spd,0,moveDir.y*spd)
					else:
						model.idle()
						velocity = Vector3.ZERO
		"Hurt":
			pass

func _on_recover_timeout():
	smp.set_trigger("recover")

func _on_smackbox_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()

func _on_timer_timeout():
	if tracker.player and tracker.alert == true:
		if global_position.distance_to(tracker.player.global_position) <= 2:
			model.slash()
			smackbox.monitoring = true
			await get_tree().create_timer(0.06).timeout
			smackbox.monitoring = false
	$smackbox/Timer.start(1)
	
