extends Node3D

@onready var exhaust_pool : Node3D = $"../../exhaust_pool"
@onready var exhaust_scene : PackedScene = preload("res:///meshes/exhaust.tscn")   # we'll fire out copies of this object

var spawntime : float = 0.05 # spawn new exhaust this often
var elapsed : float = spawntime   # total animation run time in seconds
var duration : float = 0.8 # duration of animations

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	var thrust = get_parent().thrust # directly read parent's thrust
	if elapsed>=spawntime && thrust>0:
		elapsed=0
		# Spawn new exhaust
		#print_debug("Making exhaust")
		var exhaust : MeshInstance3D = exhaust_scene.instantiate()
		if exhaust_pool != null:
			exhaust_pool.add_child(exhaust)
		exhaust.global_position = global_position
		exhaust.global_rotation = Vector3(randf_range(-3,+3), randf_range(-3,+3), randf_range(-3,+3))

		# Fire the exhaust in our global -Y axis
		var dir : Vector3 = -global_transform.basis.y
		var target : Vector3 = global_position + 2*dir

		# Fire an exhaust object toward this target
		var material = exhaust.get_surface_override_material(0).duplicate()
		exhaust.set_surface_override_material(0,material)
		material.emission_energy_multiplier = 2.0  # very bright initially
		var tween = get_tree().create_tween()   # animate toward target
		tween.set_parallel(true)  # move and change emission at same time
		tween.tween_property(exhaust, "global_position", target, duration)
		tween.tween_property(material, "emission_energy_multiplier", 0.0, duration)
		tween.tween_property(material, "grow_amount", 0.2, duration*0.75)
		tween.tween_property(material, "albedo_color:a", 0.0, duration)
		tween.chain().tween_callback(exhaust.queue_free)
