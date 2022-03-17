extends KinematicBody

export var speed = 10

var path = []
var cur_path_idx = 0
var target = null
var t1 = null
var t2 = null
var t3 = null
var velocity = Vector3.ZERO
var threshold = 0.1
var has_been_called = false
var timer: Timer
var distance2target = 2.0

onready var nav = get_parent()
var nav2: String = "NavigationMeshInstance/Level"
var twrL: String = "/TowerLeft"
var twrR: String = "/TowerRight"
var twrM: String = "/TowerMid2"
var ar: Array
var has_ex: bool = false
var attacking: bool = false


func _ready():
	var towers = get_tree().get_nodes_in_group("tower")
	for tower in towers:
		get_node(tower.get_path()).connect("twrDes", self, "_on_twrDes")

func _physics_process(_delta):
	if !attacking or !is_instance_valid(target):
		if !has_ex:
			t1 = self.get_parent().get_node(nav2 + twrM + twrL)
			t2 = self.get_parent().get_node(nav2 + twrM + twrR)
			t3 = self.get_parent().get_node(nav2 + twrM)
			ar = [[t1, dist(t1)], [t2, dist(t2)], [t3, dist(t3)]]
			target = get_min(ar)
			has_ex = true
			has_been_called = false

	if path.size() > 0:
		var _dtt = (Vector3(target.width, target.height, target.depth)/1.5).length()
		if (self.global_transform.origin - target.global_transform.origin).length() >= _dtt:
			move_to_target()
		else:
			if !has_been_called and !Globals.playerwon:
				$DmgTimer.start()
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
		self.set_rotation(Vector3(0, direct + PI, 0))
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector3.UP)

func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	cur_path_idx = 0

func do_dmg(dmg):
	target.health -= dmg
	print(target.health)

func _on_PathfindingTimer_timeout():
	if target != null:
		get_target_path(target.global_transform.origin)

func _on_DmgTimer_timeout():
	do_dmg(10)

func _on_twrDes(tower):
	if tower == "right" || tower == "left":
		has_been_called = false
		has_ex = false
	elif tower == "middle":
		$DmgTimer.stop()
		has_ex = false
		Globals.playerwon = true


func _on_Area_area_entered(area):
	if area.get_parent().is_in_group("team2"):
		attacking = true
		target = area.get_parent()
		has_ex = false
		has_been_called = false
