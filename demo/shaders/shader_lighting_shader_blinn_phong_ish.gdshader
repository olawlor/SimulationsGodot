/*
 Demo old school Blinn-Phong lighting.
*/
shader_type spatial;
render_mode unshaded;

uniform vec3 light_direction = vec3(0.0,1.0,1.5); // points toward light source in world coordinates

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 N = NORMAL; // in view space (?)
	vec4 L4 = VIEW_MATRIX * vec4(light_direction,0.0); // hardcoded world coords light vector
	vec3 L = normalize(L4.xyz); // points toward light, in view coords
	vec3 C = VIEW; // points toward camera
	//vec3 R = -L + 2.0*dot(N,L)*N; // light reflects this direction
	vec3 H = normalize(C + L); // "halfway" vector
	
	float diffuse_light = clamp(dot(N,L),0.0,1.0);
	float specular_light = pow(clamp(dot(H,N),0.0,1.0),20.0);
	//if (dot(R,C)>0.99) specular_light = 1.0; // hard highlight	
	
	float ambient_light = 0.3; // *abs(sin(2.*TIME));
	
	ALBEDO=(diffuse_light + ambient_light) * vec3(0.5,0.2,0.5) + specular_light * vec3(0,1,1);
	ROUGHNESS=0.0;	
	
}

/*
// Not used in unshaded mode:
void light() {
	// Called for every screen pixel for every light affecting the material.
	//  LIGHT_COLOR is the light's color
	//  ATTENUATION includes shadow and falloff
	vec3 N = NORMAL; // points away from the surface being rendered
	vec3 L = LIGHT; // points toward the light
	vec3 C = VIEW; // points toward the viewer
	vec3 H = normalize(L+C); // Blinn's halfway vector
	DIFFUSE_LIGHT += LIGHT_COLOR/PI * clamp(dot(N,L),0.0,1.0) * ATTENUATION;
	SPECULAR_LIGHT += vec3(0,1,1) * pow(clamp(dot(N,H),0.0,1.0),256) * ATTENUATION;
} */
