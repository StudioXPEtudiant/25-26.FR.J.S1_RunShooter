extends Area3D

signal on_realsed ()
signal on_pressed (float)
signal on_just_pressed ()
var can_interact : bool = false	

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		can_interact = true	
	
func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		can_interact = false	

func _process(_delta):
	if can_interact == true:
		
		if Input.is_action_pressed("Interact"):
			on_pressed.emit(_delta)
		if Input.is_action_just_released("Interact"):
			on_just_pressed.emit(_delta)
		if Input.is_action_just_released("Interact"):
			on_realsed.emit(_delta)
