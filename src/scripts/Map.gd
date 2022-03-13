extends Spatial

export var SmallTowerHealth = 100
export var BigTowerHealth = 300
var a = 2

export var r = 1
var tile = preload("res://src/scenes/Tile.tscn")
var enemy = preload("res://src/scenes/Enemy.tscn")

var mapcorners: String = "Navigation/NavigationMeshInstance/Level/Corners/"
var uldr = ["UL", "DR"]
var dim: Vector3 = Vector3.ZERO
var sc: int = 10

func _ready():
	for i in uldr:
		dim.x += abs(get_node(mapcorners + i).get_global_transform().origin.x)
		dim.y = abs(get_node(mapcorners + i).get_global_transform().origin.y)
		dim.z += abs(get_node(mapcorners + i).get_global_transform().origin.z)

	for i in range(-dim.x/0.4/2/sc, dim.x/0.4/2/sc):
		for j in range(-dim.z/0.4/2/sc, dim.z/0.4/2/sc):
			var tileinstance = tile.instance()
			add_child(tileinstance)
			tileinstance.global_scale(Vector3(sc, 1, sc))
			tileinstance.global_transform.origin = Vector3(0.4 * i * sc, dim.y, 0.4 * j * sc)

func _unhandled_input(event):
	if (event is InputEventMouseButton && event.button_index == 1 && event.pressed && !Globals.on_area):
		print("can't place here")

func spawn_enemy(position):
	var tileinstance = enemy.instance()
	get_node("Navigation").add_child(tileinstance)
	tileinstance.global_scale(Vector3(sc/1.5, sc/1.5, sc/1.5))
	tileinstance.global_transform.origin = position
