# Keyboard controlled object rotation around an axis
extends Node3D

# You can set these parameters in the inspector
@export var axis : Vector3 = Vector3(1,0,0) # angle to rotate around
@export var keyup : Key = KEY_W
@export var keydn : Key = KEY_S
@export var angle : float = 0.0 # rotation angle in degrees
@export var rate : float = 50.0  # degrees / second while pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var command = 0.0
	if (Input.is_physical_key_pressed(keyup)):
		command = +1.0
	if (Input.is_physical_key_pressed(keydn)):
		command = -1.0
	angle += command * rate * delta
	transform.basis = Basis(axis,angle * PI / 180.0)
