extends KinematicBody

export var speed = 0.5

var path = []
var cur_path_idx = 0
var target = null
var velocity = Vector3.ZERO
var threshold = 0.1
var has_been_called: bool = false
var timer: Timer
var distance2target: float = 5

onready var nav = get_parent()
var nav2: String = "NavigationMeshInstance/Level/Ground/"
var towerleft: String = "TowerMiddleU/TowerLeft/Position3D"
var towermiddle: String = "TowerMiddleU/Position3D"

func _ready():
	target = self.get_parent().get_node(nav2 + towerleft)
# warning-ignore:return_value_discarded
	get_parent()\
	.get_node(nav2 + towerleft)\
	.connect("TowerULDestroyed", self, "_on_Position3D_TowerULDestroyed")
	get_parent()\
	.get_node(nav2 + towermiddle)\
	.connect("TowerMidDestroyed", self, "_on_Position3D_TowerMidDestroyed")

func _physics_process(_delta):
	if path.size() > 0:
		if (self.global_transform.origin - target.global_transform.origin).length() >= distance2target:
			move_to_target()
#		else:
#			if !has_been_called:
#				$DmgTimer.start()
#				print("$DmgTimer.start()")
#				has_been_called = true

func _process(delta):
	if (self.global_transform.origin - target.global_transform.origin).length() <= distance2target:
		if !has_been_called:
			$DmgTimer.start()
			print("$DmgTimer.start()")
			has_been_called = true

func move_to_target():
	if cur_path_idx >= path.size():
		return

	if global_transform.origin.distance_to(path[cur_path_idx]) < threshold:
		cur_path_idx += 1
	else:
		var direction = path[cur_path_idx] - global_transform.origin
		velocity = direction.normalized() * speed
#		global_rotate(Vector3.UP, direction.angle())
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector3.UP)

func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	cur_path_idx = 0

func do_dmg(dmg):
	target.health -= dmg
	print(target.health)

func _on_PathfindingTimer_timeout():
	get_target_path(target.global_transform.origin)

func _on_DmgTimer_timeout():
	$AnimationPlayer.play("Fire")
	yield(get_tree().create_timer(1.0), "timeout")
	print("timeout")
	do_dmg(100)

func _on_Position3D_TowerULDestroyed():
	$AnimationPlayer.stop()
	target = get_parent().get_node(nav2 + towermiddle)
	print(target)


func _on_Position3D_TowerMidDestroyed():
	$AnimationPlayer.stop()
	$DmgTimer.stop()
	print("won")
