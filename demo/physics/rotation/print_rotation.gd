extends RigidBody3D

var print_time : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print_time -= delta
	if (print_time<0):
		print_time=1.0
		print(angular_velocity," radians/second")
