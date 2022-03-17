extends Spatial

signal twrDes(tower)

var health = 100
var tower = ""
var has_ex = false

func _process(_detla):
	if health <= 0 and !has_ex:
		visible = false
		emit_signal("twrDes", tower)
		has_ex = true
