shader_type canvas_item;

uniform float speed=1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (length(UV-vec2(0.5,0.5))<0.2*abs(sin(TIME)))
		COLOR = vec4(1,0,1,1);
	else
		COLOR = vec4(0,speed,0,0);
}
