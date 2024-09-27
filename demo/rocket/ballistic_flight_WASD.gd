# Ballistic flight simulation, including gravitational force from a single body.
#  Also rotates around using WASD keys, plus QE for roll.
extends Node3D

@export var thrust : float = 0  # 1 if currently under thrust

@export var heavy_objects : Node3D # all bodies that exert flight-relevant gravity

@export var V : Vector3 = Vector3(12,0,0) # velocity, m/s
@export var m : float = 10000.0; # mass of rocket in kg
@export var rocket_thrust : float = 100000; # newtons of thrust (100 kN, produces 1g acceleration with 10 tonne rocket)

var print_time : float = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print_time -= delta;
	var doprint : bool = false
	if (print_time<0):
		print_time=1.0
		doprint=true
	
	var F : Vector3 = Vector3(0,0,0);
	
	for body in heavy_objects.get_children():
		#  Newtonian gravity:  F = G * m1 * m2 / r^2
		
		# Point the radius vector R toward the source body:
		var sourceP : Vector3 = body.global_position
		var R : Vector3 = sourceP - global_position
		#if doprint: print(" Pos: ",global_position, " to ", sourceP)
		var G : float = 6.6743e-11  # universal gravitational constant
		var bodyM : float = 2.0e15  # that asteroid has a black hole inside!? (kg)
		var f : float = G * m * bodyM / R.dot(R)  # newtons (scalar)
		
		var gravity_body : Vector3 = f * (R.normalized()) # newtons (vector)
		if doprint: print("   Body altitude: %.0f m   Gravity: %.0f N" % [R.length(), f] )
		F += gravity_body  # add gravity to our net force
	
	# Fly rocket around using thrust (until we're out of propellant)
	if (Input.is_physical_key_pressed(KEY_SPACE) && m>=1000.0):
		F += transform.basis.x * rocket_thrust;
		var prop_burn_rate : float = 100; # kg/sec prop burned
		m -= prop_burn_rate * delta;
		thrust = 1
	else:
		thrust = 0
	
	var A : Vector3 = F/m; 
	if doprint: print("Ship mass: %.1f tonnes  velocity: (%.0f,%.0f,%.0f) m/s   Accel: %.2f m/s^2" % [m*0.001, V.x, V.y, V.z, A.length() ])
	
	# Aspel-Cromer symplectic Euler integrator
	V += A * delta;
	transform.origin += V * delta;
	
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
	
	
	# Reorient rocket by adjusting our basis
	var move : float = 0.5 # rotate speed (radians/sec)
	# pitch
	transform.basis.z += transform.basis.x * -ad * move * delta
	transform.basis.x -= transform.basis.z * -ad * move * delta
	
	# yaw
	transform.basis.y += transform.basis.x * ws * move * delta
	transform.basis.x -= transform.basis.y * ws * move * delta
	
	# roll
	transform.basis.y += transform.basis.z * -qe * move * delta
	transform.basis.z -= transform.basis.y * -qe * move * delta
	
	transform.basis = transform.basis.orthonormalized()  # avoid shear
