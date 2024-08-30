# Demonstrate nudge coordinate system around using the basis
extends Node3D

@export var thrust : float = 0  # 1 if currently under thrust

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ad : float = 0  # A-D axis
	if (Input.is_physical_key_pressed(KEY_A)):
		ad = -1
	if (Input.is_physical_key_pressed(KEY_D)):
		ad = +1
	
	var ws : float = 0 # W-S axid (up-down)
	if (Input.is_physical_key_pressed(KEY_W)):
		ws = +1
	if (Input.is_physical_key_pressed(KEY_S)):
		ws = -1
	
	if (Input.is_physical_key_pressed(KEY_SPACE)):
		var speed = 10.0 # flight speed (m/s)
		transform.origin += transform.basis.y * speed * delta
		thrust = 1
	else:
		thrust = 0
	
	
	
	# Shear our X axis using the keyboard
	var move : float = 0.5 # rotate speed (radians/sec)
	transform.basis.x += transform.basis.y * -ad * move * delta
	#transform.basis.y -= transform.basis.x * ad * move * delta
	
	transform.basis.y += transform.basis.z * ws * move * delta
	#transform.basis.z -= transform.basis.y * ws * move * delta
	
	transform.basis = transform.basis.orthonormalized()  # avoid shear
