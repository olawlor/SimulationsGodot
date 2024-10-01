# Apply force using the WASDQE keys.
extends RigidBody3D

# Called every physics frame
func _physics_process(_delta: float) -> void:	
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
	
	var strength : float = 150.0 # newtons of force
	constant_force = strength*Vector3(ad,ws,qe)
