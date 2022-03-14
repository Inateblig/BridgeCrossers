extends KinematicBody

export var speed = 0.5

var path = []
var cur_path_idx = 0
var target = null
var t1 = null
var t2 = null
var t3 = null
var velocity = Vector3.ZERO
var threshold = 0.1
var has_been_called: bool = false
var timer: Timer
var distance2target: float = 5

onready var nav = get_parent()
var nav2: String = "NavigationMeshInstance/Level/Ground/"
var towerleft: String = "TowerMiddleU/TowerLeft/Position3D"
var towerright: String = "TowerMiddleU/TowerRight/Position3D"
var towermiddle: String = "TowerMiddleU/Position3D"
var ar: Array
var has_ex: bool = false


func _ready():
# warning-ignore:return_value_discarded
	get_parent()\
	.get_node(nav2 + towerleft)\
	.connect("TowerULDestroyed", self, "_on_Position3D_TowerULDestroyed")
# warning-ignore:return_value_discarded
	get_parent()\
	.get_node(nav2 + towerright)\
	.connect("TowerURDestroyed", self, "_on_Position3D_TowerURDestroyed")
# warning-ignore:return_value_discarded
	get_parent()\
	.get_node(nav2 + towermiddle)\
	.connect("TowerMidDestroyed", self, "_on_Position3D_TowerMidDestroyed")

func _physics_process(_delta):
	if !has_ex:
		t1 = self.get_parent().get_node(nav2 + towerleft)
		t2 = self.get_parent().get_node(nav2 + towerright)
		t3 = self.get_parent().get_node(nav2 + towermiddle)
		ar = [[t1, dist(t1)], [t2, dist(t2)], [t3, dist(t3)]]
#		print(ar)
		target = get_min(ar)
#		print(target)
		has_ex = true

	if path.size() > 0:
		if (self.global_transform.origin - target.global_transform.origin).length() >= distance2target:
			move_to_target()
		else:
			if !has_been_called and !Globals.won:
				$DmgTimer.start()
#				print("$DmgTimer.start()")
				has_been_called = true

func dist(t):
	return (t.global_transform.origin - self.global_transform.origin).length_squared()

func get_min(array):
	var mi = -1
	var md: float
	for i in array.size():
		if !array[i][0].is_visible_in_tree():
#			print("continue")
			continue
		if mi < 0 or md > array[i][1]:
			mi = i
			md = array[i][1]
	if mi < 0:
		return array[2][0]
	return array[mi][0]

func move_to_target():
	if cur_path_idx >= path.size():
		return

	if global_transform.origin.distance_to(path[cur_path_idx]) < threshold:
		cur_path_idx += 1
	else:
		var direction = path[cur_path_idx] - global_transform.origin
		velocity = direction.normalized() * speed
		var direct = Vector2(direction.z, direction.x).angle() - PI
		self.set_rotation(Vector3(0, direct, 0))
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector3.UP)

func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	cur_path_idx = 0

func do_dmg(dmg):
	target.health -= dmg
#	print(target.health)

func _on_PathfindingTimer_timeout():
	if target != null:
		get_target_path(target.global_transform.origin)

func _on_DmgTimer_timeout():
	$AnimationPlayer.play("Fire")
	yield(get_tree().create_timer(1.5), "timeout")
#	print("timeout")
	do_dmg(100)

func _on_Position3D_TowerULDestroyed():
	$AnimationPlayer.play("RESET")
	$DmgTimer.stop()
#	print($DmgTimer.get_wait_time())
	target = get_parent().get_node(nav2 + towermiddle)
	has_been_called = false
	ar.remove(0)
	has_ex = false

func _on_Position3D_TowerURDestroyed():
	$AnimationPlayer.play("RESET")
	$DmgTimer.stop()
#	print($DmgTimer.get_wait_time())
	target = get_parent().get_node(nav2 + towermiddle)
	has_been_called = false
	ar.remove(1)
	has_ex = false


func _on_Position3D_TowerMidDestroyed():
	$AnimationPlayer.play("RESET")
	$DmgTimer.stop()
	ar.remove(2)
	has_ex = false
	Globals.won = true
	print("won")
