shader_type spatial;
render_mode unshaded;

uniform float scale = 1.0;
uniform vec3 shade : source_color = vec3(1,1,1);

varying vec3 world;
void vertex()
{
	world = (MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
}


void fragment() {
	ALBEDO=shade * fract(scale*world);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
