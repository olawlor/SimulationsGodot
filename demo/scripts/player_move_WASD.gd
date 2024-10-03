#  Simple WASD motion forward along +Z, and turn left and right
#  Built in class
extends Node3D

@export var turnrate : float = 120.0 # in degrees/second
@export var moverate : float = 5.0 # in meters/second
@export var angle = 0 # our current orientation angle (degrees)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var turn = 0  # how much we want to turn
	if (Input.is_physical_key_pressed(KEY_A)):
		turn = +1
	if (Input.is_physical_key_pressed(KEY_D)):
		turn = -1
	
	angle += turnrate * turn * delta
	transform.basis = Basis(Vector3(0,1,0),deg_to_rad(angle))
	
	
	var move = 0 # how far we want to move
	if (Input.is_physical_key_pressed(KEY_W)):
		move = +1
	if (Input.is_physical_key_pressed(KEY_S)):
		move = -1
	
	# The direction we want to move is our -Z axis
	var movedir : Vector3 = -transform.basis.z
	transform.origin += delta * move * moverate * movedir

	# For 2D rotations, it's not too bad to do the same thing with raw trig,
	#  but for 3D using vectors is much better.
	#if (Input.is_physical_key_pressed(KEY_W)):
	#	transform.origin.x -= sin(deg_to_rad(angle)) * delta
	#	transform.origin.z -= cos(deg_to_rad(angle)) * delta
