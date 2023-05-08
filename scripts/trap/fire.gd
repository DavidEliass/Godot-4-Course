extends StaticBody2D

@onready var state_timer: Timer = get_node("StateTimer")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

var current_state: String = "off"

@export var damage: int

func on_state_timer_timeout():
	state_timer.start()
	
	if current_state == "off":
		current_state = "on"
		animation.play(current_state)
		return

	if current_state == "on":
		current_state = "off"
		animation.play(current_state)
		return

func on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		body.update_health(global_position, damage, "decrease")
	
