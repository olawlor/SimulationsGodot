# Demonstrate manually modifing transform.basis using keyboard
extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ad : float = 0  # A-D axis
	if (Input.is_physical_key_pressed(KEY_A)):
		ad = -1
	if (Input.is_physical_key_pressed(KEY_D)):
		ad = +1
	
	var ws : float = 0 # W-S axis (up-down)
	if (Input.is_physical_key_pressed(KEY_W)):
		ws = +1
	if (Input.is_physical_key_pressed(KEY_S)):
		ws = -1
	
	# Shear our X axis using the keyboard
	var move : float = 0.5
	transform.basis.x.z = ad * move
	transform.basis.x.y = ws * move
	#transform.basis = transform.basis.orthonormalized()  # avoid shear
