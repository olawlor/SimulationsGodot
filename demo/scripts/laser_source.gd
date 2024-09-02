extends Node3D

@onready var laser_pool : Node3D = $"../../laser_pool"
@onready var laser_scene : PackedScene = preload("res:///meshes/laser_inflight.tscn") 

var spawntime : float = 0.05 # spawn new bolt this often
var elapsed : float = spawntime   # total animation run time in seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	var enable = Input.is_action_pressed("fire_laser")
	if elapsed>=spawntime && enable:
		elapsed=0
		
		# Spawn new object
		var n = laser_scene.instantiate()
		if laser_pool != null:
			laser_pool.add_child(n)
		
		# Jitter the laser spawn point around slightly
		var j : float = 0.2
		n.global_position = global_position + Vector3(randf_range(-j,+j), randf_range(-j,j), randf_range(-j,j))

		# Laser should be aligned along flight direction	
		var i = global_transform.basis # input coord system
		var dir = global_transform.basis.y	
		var o = n.global_transform.basis # output coord system
		o.x = dir
		o.y = i.x
		o.z = i.z
		n.global_transform.basis = o.orthonormalized()
		
		var maxrange = 500.0 # meters
		var target : Vector3 = global_position + maxrange*dir

		# Fire new object toward this target
		var tween = get_tree().create_tween()   # animate toward target
		tween.tween_property(n, "global_position", target, 1.5)
		tween.chain().tween_callback(n.queue_free)
