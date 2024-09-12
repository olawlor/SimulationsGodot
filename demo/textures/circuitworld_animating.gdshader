shader_type spatial;

uniform sampler2D circuit : filter_linear_mipmap_anisotropic;
uniform sampler2D glowblobs : filter_linear_mipmap_anisotropic;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0,0,0);
	vec2 tcB = 1.0 * UV;
	vec3 colorB = texture(circuit,tcB).rgb;
	vec3 blobB = texture(glowblobs,tcB + 0.2*TIME*vec2(0.9,0.2)).rgb;
	colorB.b *= (1.0 + 20.0*blobB.r);
	
	vec2 tcM = 20.0 * UV;
	vec3 colorM = texture(circuit,tcM).rgb;
	vec3 blobM = texture(glowblobs,tcM + 0.2*TIME*vec2(-0.2,0.8)).rgb;
	colorM.b *= (1.0 + 1.5*blobM.r);
	
	EMISSION = colorB*0.3 + colorM*0.4; // weighted average
	//EMISSION = (colorB + 0.3) * (colorM + 0.3) * (colorL + 0.3);
	//EMISSION = tc.xxy; // debug UVs
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
