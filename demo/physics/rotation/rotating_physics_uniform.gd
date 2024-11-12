extends Node3D

# Rotation rate, degrees/second
@export var rate : float = 30 

# Called every physics frame.
func _physics_process(delta: float) -> void:
	global_rotation.z += delta*deg_to_rad(rate)
