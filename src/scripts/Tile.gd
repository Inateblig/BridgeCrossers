extends Area

#func _ready():
#	if colliding:
#		queue_free()

func _process(_delta):
	if Globals.show_sprites:
		$Sprite3D.visible = true
	else:
		$Sprite3D.visible = false

func _on_Area_mouse_entered():
	$Sprite3D.visible = true
	Globals.on_area = true

func _on_Area_mouse_exited():
	$Sprite3D.visible = false
	Globals.on_area = false


func _on_Area_input_event(_camera, event, _position, _normal, _shape_idx):
	if (event is InputEventMouseButton && event.button_index == 1 && event.pressed):
		get_parent().spawn_enemy($Sprite3D.global_transform.origin)
