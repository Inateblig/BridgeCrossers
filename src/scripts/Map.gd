extends Spatial

export var SmallTowerHealth = 100
export var BigTowerHealth = 300
var a = 2

export var r = 1
var tile = preload("res://src/scenes/Tile.tscn")
var enemy = preload("res://src/scenes/Enemy.tscn")

var mapcorners: String = "Navigation/NavigationMeshInstance/Level/Corners/"
var siz: Vector2
var sc: Vector2
var col: int = 30
var row: int = 30
var dlpos: Vector3
var urpos: Vector3

func _ready():
	dlpos = get_node(mapcorners + "DL").get_global_transform().origin
	urpos = get_node(mapcorners + "UR").get_global_transform().origin

	siz.x = urpos.x - dlpos.x
	siz.y = dlpos.z - urpos.z

	sc.x = siz.x/col
	sc.y = siz.y/row

	for x in range(col):
		for y in range(row):
			var tileinstance = tile.instance()
			add_child(tileinstance)
			tileinstance.set_scale(Vector3(sc.x, 1, sc.y))
			tileinstance.global_transform.origin\
				= dlpos - Vector3(-x * sc.x, 0, y * sc.y)

func _unhandled_input(event):
	if (event is InputEventMouseButton && event.button_index == 1 && event.pressed && !Globals.on_area):
		print("can't place here")

func spawn_enemy(position):
	var tileinstance = enemy.instance()
	get_node("Navigation").add_child(tileinstance)
	tileinstance.global_scale(Vector3(sc.x/0.5, (sc.x + sc.y) / 2 / 0.5, sc.y/0.5))
	tileinstance.global_transform.origin = position
