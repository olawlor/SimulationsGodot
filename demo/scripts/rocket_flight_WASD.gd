# Demonstrate nudge coordinate system around using the basis
extends Node3D

@export var thrust : float = 0  # 1 if currently under thrust

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ad : float = 0  # A-D axis (yaw)
	if (Input.is_physical_key_pressed(KEY_A)):
		ad = -1
	if (Input.is_physical_key_pressed(KEY_D)):
		ad = +1
	
	var ws : float = 0 # W-S axis (pitch)
	if (Input.is_physical_key_pressed(KEY_W)):
		ws = +1
	if (Input.is_physical_key_pressed(KEY_S)):
		ws = -1
	
	var qe : float = 0 # Q-E axis (roll)
	if (Input.is_physical_key_pressed(KEY_Q)):
		qe = +1
	if (Input.is_physical_key_pressed(KEY_E)):
		qe = -1
	
	# Fly rocket around using thrust
	if (Input.is_physical_key_pressed(KEY_SPACE)):
		var speed = 10.0 # flight speed (m/s)
		transform.origin += transform.basis.y * speed * delta
		thrust = 1
	else:
		thrust = 0
	
	
	# Reorient rocket by adjusting our basis
	var move : float = 0.5 # rotate speed (radians/sec)
	# pitch
	transform.basis.x += transform.basis.y * -ad * move * delta
	#transform.basis.y -= transform.basis.x * -ad * move * delta
	
	# yaw
	transform.basis.y += transform.basis.z * ws * move * delta
	#transform.basis.z -= transform.basis.y * ws * move * delta
	
	# roll
	transform.basis.x += transform.basis.z * qe * move * delta
	# transform.basis.z -= transform.basis.x * qe * move * delta
	
	transform.basis = transform.basis.orthonormalized()  # avoid shear
