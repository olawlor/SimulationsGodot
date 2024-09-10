shader_type spatial;

uniform float size = 1.0;
uniform float bright = 1.0;
/** spiky from normal */
uniform float spikyN : hint_range(-0.4,0.4) = 0.4; 
/** spiky from color */
uniform float spikyC = 0.0; 
uniform vec3 color : source_color = vec3(1.0,0.6,0.4);

void vertex() {
	// Called for every vertex the material is visible on.
	
	VERTEX = VERTEX * size + NORMAL*spikyN + COLOR.rgb*spikyC;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = color;
	EMISSION = bright * color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
