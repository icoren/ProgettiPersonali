extends MeshInstance3D

#const TraversalCost:int = 50
const Traversable: bool = true
const tag: String = "Sabbia"
var Heuristic: int = 0
var G_Cost: int = 3
const Static_G_Cost: int = 3
var CubeCoords
var parent: Object
signal hex_destination_selected

func _ready():
	pass 



func _process(_delta):
	pass


func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			hex_destination_selected.emit(self)
