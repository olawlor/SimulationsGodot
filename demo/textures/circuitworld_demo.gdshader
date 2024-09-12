shader_type spatial;

uniform sampler2D circuit : filter_linear_mipmap_anisotropic;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float repeat=4.0;
	vec2 tc = repeat*UV; // my texture coordinates
	ALBEDO = vec3(0,0,0);
	EMISSION = texture(circuit,tc).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
