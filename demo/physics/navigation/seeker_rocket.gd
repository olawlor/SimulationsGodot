extends RigidBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var target : Node3D = null

func _physics_process(_delta):
	if (target==null): 
		return
	nav.target_position = target.global_position 
	var go = nav.get_next_path_position()
	var dir = (go - global_position).normalized()
	var levitate =  Vector3(0,1,0)*900
	var seek = dir * 500
	apply_force(seek + levitate)
