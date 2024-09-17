@tool
extends Node3D

var time : float = 0;
func _process(delta: float) -> void:
	time += delta;
	rotation.y = 0.1*time;
