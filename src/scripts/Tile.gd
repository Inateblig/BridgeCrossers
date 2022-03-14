extends Area


func _ready():
# warning-ignore:return_value_discarded
	get_parent()\
	.get_node(".")\
	.connect("body_entered", self, "_on_Tile_body_entered")
func _process(_delta):
	if Globals.show_sprites:
		$Sprite3D.visible = true
	else:
		$Sprite3D.visible = false

#func _on_Area_mouse_entered():
#	$Sprite3D.visible = true
#	Globals.on_area = true
#
#func _on_Area_mouse_exited():
#	$Sprite3D.visible = false
#	Globals.on_area = false


func _on_Area_input_event(_camera, event, position, _normal, _shape_idx):
	Globals.position = position
	if (event is InputEventMouseButton && event.button_index == 1 && event.pressed):
		get_parent().spawn_enemy(Globals.position)


#func _on_Tile_body_entered(_body):
#	queue_free()
