# Camera tracking script: keeps fixed offset from target
extends Node3D

@export var track : Node3D   # We should track this object
@export var offset : Vector3 = Vector3(0,2,4) # distance to camera
@export var rate : float = 1.5 # rate of convergence to offset (higher = faster, units 1/seconds)
@export var basis_rate : float = 1.0 # rate of convergence of basis

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if track == null:
		return
	
	var tbasis : Basis = track.global_transform.basis
	var where = offset # offset in global coords
	if basis_rate>0:
		where = tbasis*offset # offset in object coords
	var target : Vector3 = track.global_position + where
	global_position = lerp(global_position,target,delta*rate)

	if (basis_rate>0):
		global_transform.basis = lerp (global_transform.basis,tbasis,delta*basis_rate).orthonormalized()
