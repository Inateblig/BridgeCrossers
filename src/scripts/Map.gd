extends Spatial

var warior = preload("res://src/scenes/Warior.tscn")
var _has_ex = false

func spawn_warior(pos):
	var wariorinstance = warior.instance()
	get_node("Navigation").add_child(wariorinstance)
	wariorinstance.global_transform.origin = pos

func _process(delta):
	if Globals.playerwon and !_has_ex:
		print("Player won")
		_has_ex = true

func _on_Area_input_event(_camera, event, position, _normal, _shape_idx):
	if event is InputEventMouseButton && event.pressed:
		match event.button_index:
			1:
					spawn_warior(position)
#			2:
#				get_parent().spawn_player(Globals.position)
