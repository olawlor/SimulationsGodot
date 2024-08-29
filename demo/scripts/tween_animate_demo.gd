extends Node3D

@onready var exhaust : MeshInstance3D = $Exhaust   # we'll fire out copies of this object
var elapsed : float = 0
var duration : float = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exhaust == null:
		return
	elapsed += delta
	if elapsed<duration:
		return
	elapsed=0

	# Change this to see what the coordinate system is doing!	
	var target = transform.basis.x * 4

	# Fire an exhaust object toward this target
	exhaust.position=Vector3(0,0,0)
	var material = exhaust.get_surface_override_material(0)
	material.emission_energy_multiplier = 2.0
	var tween = get_tree().create_tween()   # animate toward target
	tween.set_parallel(true)  # move and change emission at same time
	tween.tween_property(exhaust, "position", target, duration)
	tween.tween_property(material, "emission_energy_multiplier", 0.0, duration)
