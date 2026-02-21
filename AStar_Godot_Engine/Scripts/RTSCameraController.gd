extends Node3D


# bug se attivato zoom su cursore mouse. da non usare se non fixato


#####################
# EXPORT PARAMS
#####################
#movement params ExportRange fa comparire la variabile nell'editor, con valore max di 1000 e minimo di 0
@export_range(0,1000,0.25) var mv_speed = 20
#rotation params
@export_range(0,90,1) var min_elevation_angle = 10
@export_range(0,90,1) var max_elevation_angle = 90
@export_range(0,1000,0.25) var rotation_speed = 10
#zoom params
@export_range(0,1000,0.1) var min_zoom = 0.1
@export_range(0,1000,1) var max_zoom = 90
@export_range(0,1000,0.25) var zoom_speed = 30
@export_range(0,1,0.1) var zoom_speed_damp = 0.5
########
# FLAGS
########
@export var allow_rotation = true
@export var inverted_y = false
@export var zoom_to_cursor = false
#########
# PARAMS
#########
# mouse position
var _last_mouse_position: Vector2 = Vector2.ZERO
# rotation
var _is_rotating: bool = false
@onready var elevation = $Elevation
# zoom
var _zoom_direction = 0 
@onready var camera = $Elevation/Camera
const GROUND_PLANE = Plane(Vector3.UP,0)
const RAY_LENGTH = 1000


func _process(delta) -> void:
	_move(delta)
	_rotate(delta)
	_zoom(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("MiddleMouseClick"):
		_is_rotating = true
		_last_mouse_position = get_viewport().get_mouse_position() # Questa riga di codice è essenziale, se non ci fosse, ci sarebbe uno scatto ogni volta che ripremiamo il middle button del mouse, in quanto la posizione sarebbe di nuovo al centro dello schermo. inoltre se non ci fosse, ripartendo sempre dal centro avremmo un range max di rotazione (se volessimo girare di molto a sinistra la camera non potremmo, in quanto se clicckiamo e giriamo e poi rilasciamo essendosi resettata la posizione non continueremmo da dove ci eravamo fermati)
	if event.is_action_released("MiddleMouseClick"):
		_is_rotating = false
	#test for scrolling
	if event.is_action_pressed("ScrollUp"):
		_zoom_direction = -1
		print(_zoom_direction)
	if event.is_action_pressed("ScrollDown"):
		_zoom_direction = 1
		print(_zoom_direction)

func _move(delta) -> void:
	#initialize velocity vector
	var velocity = Vector3.ZERO
	#populate based on player input
	if Input.is_action_pressed("moveup"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("movedown"):
		velocity += transform.basis.z
	if Input.is_action_pressed("moveleft"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("moveright"):
		velocity += transform.basis.x
	velocity = velocity.normalized()
	#translate into camera movement
	position += mv_speed * delta * velocity

func _rotate(delta) -> void:	
	if not _is_rotating or not allow_rotation:
		return
	#calculate mouse movement
	var displacement = _get_mouse_displacement()
	#use horizontal displacement to rotate
	_rotate_left_right(delta, displacement.x)
	#use vertical displacement to elevate
	_elevate(delta, displacement.y)


func _zoom(delta:float) -> void:
	#calculate new zoom and clamp it between max and min
	var new_zoom = clamp(
		camera.position.z + zoom_speed * delta* _zoom_direction,
		min_zoom,
		max_zoom
	)
	
	
	#save 3d position
	#var pointing_at = _get_ground_click_location()
	
	
	#zoom
	camera.position.z = new_zoom
	#move the camera such that we are pointing at the same location
	
	
	#if zoom_to_cursor and pointing_at != null:
		#_realign_camera(pointing_at)
	
	
	
	#stop scrolling
	_zoom_direction *= zoom_speed_damp
	if abs(_zoom_direction) <= 0.0001:
		_zoom_direction = 0


func _get_mouse_displacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - _last_mouse_position
	_last_mouse_position = current_mouse_position
	return displacement

func _rotate_left_right(delta:float , val: float) -> void:
	rotation_degrees.y += val * delta * rotation_speed

func _elevate(delta:float, val:float) -> void:
	#calculate new elevation
	var new_elevation = elevation.rotation_degrees.x
	if inverted_y:
		new_elevation -= val * delta * rotation_speed
	else:
		new_elevation += val * delta * rotation_speed
	#clamp new elevation
	new_elevation = clamp(
		new_elevation,
		-max_elevation_angle,
		-min_elevation_angle
		)
	elevation.rotation_degrees.x = new_elevation
	#set new elevation based on clamped value


#func _get_ground_click_location() -> Vector3:
	#var mouse_pos = get_viewport().get_mouse_position()
	#var ray_from = camera.project_ray_origin(mouse_pos)
	#var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH 
	#return GROUND_PLANE.intersects_ray(ray_from,ray_to)
#
#func _realign_camera(location: Vector3) -> void:
	##calculate where we need to move
	#var new_location = _get_ground_click_location()
	#var displacement = location - new_location
	##move camera based on the calculation
	#position += displacement
