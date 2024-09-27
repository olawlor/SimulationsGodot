# Camera tracking script: keeps fixed offset from target
extends Node3D

@export var track : Node3D   # We should track this object
@export var offset : Vector3 = Vector3(0,2,4) # distance to camera
@export var rate : float = 1.5 # rate of convergence to offset (higher = faster, units 1/seconds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if track == null:
		return
	
	var tbasis : Basis = track.global_transform.basis
	
	var target : Vector3 = track.global_position + tbasis*offset
	global_position = lerp(global_position,target,2.0*delta*rate)
	
	global_transform.basis = lerp (global_transform.basis,tbasis,delta*rate).orthonormalized()
