extends ProgressBar

@export var reset_at_end: bool = false
var pressed: bool = false
@onready var timer_bouton = %timerbouton

func _on_zone_dinteraction_on_just_pressed(_arg) -> void:
	timer_bouton.start()
	pressed = true


func _on_timerbouton_timeout() -> void:
	if pressed == true:
		set_value(value + 1)
		print("continue")


func _on_zone_dinteraction_on_realsed(_arg) -> void:
	timer_bouton.stop()
	pressed = false
	print("fini")
	if reset_at_end == true:
		self.value = self.min_value
