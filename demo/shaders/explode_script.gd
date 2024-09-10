@tool   #<- runs this script in editor, not just in game
extends Node3D

@onready var mtl : ShaderMaterial = $Explode.get_surface_override_material(0)

var time : float = 0
func _process(delta: float) -> void:
	time += delta;
	var v = abs(sin(time));
	mtl.set("shader_parameter/size",v*2.0+0.5);
	mtl.set("shader_parameter/bright",1.0/(v+0.2));
	mtl.set("shader_parameter/spikyN",0.1*v);
