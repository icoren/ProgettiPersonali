extends Camera3D


# bug se attivato zoom su cursore mouse. da non usare se non fixato


#####################
# EXPORT PARAMS
#####################
#movement params ExportRange fa comparire la variabile nell'editor, con valore max di 1000 e minimo di 0
@export_range(0,1000,0.25) var mv_speed = 8
#rotation params
@export_range(0,1000,0.1) var rotation_speed = 0.3

########
# FLAGS
########
@export var allow_rotation = true
#########
# PARAMS
#########


func _process(delta) -> void:
	_move(delta)
	_rotate(delta)

#func _unhandled_input(event: InputEvent) -> void:


func _move(delta) -> void:
	#initialize velocity vector
	var velocity = Vector3.ZERO
	#populate based on player input
	if Input.is_action_pressed("zoomin"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("zoomout"):
		velocity += transform.basis.z
	if Input.is_action_pressed("moveleft"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("moveright"):
		velocity += transform.basis.x
	if Input.is_action_pressed("moveahead"):
		velocity -= Vector3(transform.basis.z.x,0,transform.basis.z.z)
	if Input.is_action_pressed("movebehind"):
		velocity += Vector3(transform.basis.z.x,0,transform.basis.z.z) #*cos(PI/6)
	velocity = velocity.normalized()
	# transform.basis.z.x*cos(PI/6)
	position += mv_speed * delta * velocity

#func _rotate(delta) -> void:
	#if Input.is_action_pressed("E"):
		#rotation_degrees.y += 20
	#if Input.is_action_pressed("Q"):
		#rotation_degrees.y -= 20
	#rotation.y = rotation_speed*delta

func _rotate(delta):
	var rotation_change = Vector3.ZERO
	# If 'E' is pressed, rotate clockwise
	if Input.is_action_pressed("E"):
		rotation_change.y += 5
	# If 'Q' is pressed, rotate counterclockwise
	if Input.is_action_pressed("Q"):
		rotation_change.y -= 5
	# Apply the accumulated rotation change to the rotation property
	rotation += rotation_change * rotation_speed * delta
