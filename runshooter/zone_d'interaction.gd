extends Area3D

var can_interact : bool = false	
@onready var label_message = $Label3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		label_message.text = "interact"
		can_interact = true	
	


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		label_message.text = ""
		can_interact = false	

func _process(_delta):
	if can_interact == true:
		if Input.is_action_just_pressed("Interact"):
			print("gg")
