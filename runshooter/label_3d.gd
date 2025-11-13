extends Label3D
func _process(delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		global_rotation = camera.global_rotation
