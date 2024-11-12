/*
 Render the shallow-water wave equation onscreen

 Dr. Orion Lawlor, lawlor@alaska.edu, 2024-10-23 (Public Domain)
*/
shader_type canvas_item;

uniform sampler2D last_frame : filter_nearest;
uniform sampler2D rando_texture : repeat_enable, filter_nearest; // randomizes roundoff

void vertex() {
}

void fragment() {
	// Center pixel is us
	vec4  C  = texture(last_frame,UV);

	// Find neighbor pixels
	vec2 uvSize = 1.0/vec2(textureSize(last_frame,0));
	vec4  T  = texture(last_frame,UV + vec2(0,-uvSize.y));
	vec4   R = texture(last_frame,UV + vec2(+uvSize.x,0));
	vec4 L   = texture(last_frame,UV + vec2(-uvSize.x,0));
	vec4  B  = texture(last_frame,UV + vec2(0,+uvSize.y));
	float gridsize = 1.0; // 1 meter (for 2 pixels)
	vec4 d_dx = (R-L)/gridsize; // delta U / delta x
	vec4 d_dy = -(T-B)/gridsize; // delta U / delta y

	// Fluid constants
	float H = 1.0; // depth of fluid (meters)
	float g = 1.0; // gravity acceleration (m/s^2)
	float k = 0.0; // viscosity (fraction)

	// Equations uvh
	// Colors    xyz
	float dhdt = -H * (d_dx.x + d_dy.y);
	float dudt = -g * d_dx.z - k*C.x;
	float dvdt = -g * d_dy.z - k*C.y;

	vec4 d_dt = vec4(dudt, dvdt, dhdt, 0.0);

	// Take timestep
	float dt = 0.25;
	float stability = 0.28;
	float grayscale = 0.0005;

	vec4 new_C = C + d_dt*dt; // from physics

	// Blurring for stability
	vec4 neighbor = (L + R + T + B)*0.25;
	vec4 stable_C = mix(new_C, neighbor, stability);

	// Blend to gray to avoid pastel clipping
	vec4 target_gray = vec4(0.5);
	vec4 gray_C = mix(stable_C, target_gray, grayscale);

	// Add "stochasic resonance" noise, to work around quantization error
	float add_noise = 1.0/255.0;
	vec4 noise = texture(rando_texture,UV + fract(vec2(TIME,5.345*TIME)));
	vec4 noisy_C = gray_C + add_noise*(noise-0.5);
	
	COLOR = noisy_C;



	// Add a solid color ball in the middle
	if (length(UV-vec2(0.5,0.5))<0.1*abs(sin(TIME)))
		COLOR = vec4(0.7,0.7,0.7,1);

	// Wave generator
	if (UV.x<0.05) {
		float waverate = 8.0*TIME;
		COLOR = 0.5 + 4.0*vec4(0.4*sin(waverate),0.0,0.4*sin(waverate),1.0);
	}

	COLOR.a = 1.0; // opaque pixels
}
