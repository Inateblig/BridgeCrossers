extends Position3D

signal TowerMidDestroyed

var health = Globals.TowerMidHealth
var has_been_called = false

func _process(_delta):
	if health <= 0 and !has_been_called:
		get_parent().visible = false
		emit_signal("TowerMidDestroyed")
		Globals.TowerMidDestroyed = true
		has_been_called = true
		print("invisible")
