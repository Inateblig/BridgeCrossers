extends Position3D

signal TowerULDestroyed

var health = Globals.TowerHealth
var has_been_called = false

func _process(_delta):
	if health <= 0 and !has_been_called:
		get_parent().visible = false
		emit_signal("TowerULDestroyed")
		Globals.TowerULDestroyed = true
		has_been_called = true
		print("invisible")
