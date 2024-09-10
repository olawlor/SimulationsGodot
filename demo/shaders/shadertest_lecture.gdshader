shader_type spatial;

float myclamp(float v, float lo, float hi) {
	if (v<lo) return lo;
	if (v>hi) return hi;
	return v;
}

uniform float ripple_control = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	vec4 w = MODEL_MATRIX * vec4(VERTEX, 1.0); // world coords
	float inflate = sin(w.x * 20.0 + TIME*0.0);
	if (COLOR.r<0.5) {
		inflate = myclamp(inflate,0.0,0.1);
		
	}
	VERTEX = VERTEX + 0.02*ripple_control*inflate*NORMAL;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	//ALBEDO = COLOR.grb; // vec3(COLOR.r,COLOR.g,COLOR.b); // vec3(1,0,0);
	if (COLOR.r>0.5) {
		ALBEDO = vec3(1,0,1);
	}
	else {
		ALBEDO.r = COLOR.g;
		ALBEDO.g = sin(COLOR.r);
		ALBEDO.b = COLOR.b;
	}
	//ALBEDO = fract(NORMAL);
	//ALBEDO = UV.xyy;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
