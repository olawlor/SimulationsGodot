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

	// Our 4 neighbors top, bottom, left, right
	vec2 shift = 1.0/vec2(textureSize(last_frame,0));
	vec4  T  = texture(last_frame,UV + vec2(0,-shift.y));
	vec4 L   = texture(last_frame,UV + vec2(-shift.x,0));
	vec4   R = texture(last_frame,UV + vec2(+shift.x,0));
	vec4  B  = texture(last_frame,UV + vec2(0,+shift.y));

	// Compute our new color, based on our neighbors
	float H = 1.0; // mean height (meters)
	float g = 1.0; // gravity accleration (m/s^2)
	float k = 0.0; // viscous drag (fraction)
	float gridsize = 1.0; // spatial distance for 2 grid cells (meters)

	// Shallow-water wave equations!
	vec4 d_dx = (R-L)/gridsize; // how we change with space
	vec4 d_dy = (T-B)/gridsize;
	// Equation uvH = xyz in our pixels
	float dh_dt = -H*(d_dx.x + d_dy.y); // shallow water wave equations
	float du_dt = -g*d_dx.z - k*C.x;
	float dv_dt = -g*d_dy.z - k*C.y;
	vec4 d_dt = vec4(du_dt,dv_dt,dh_dt,0.0); // how we change with time

	// Time integration, and stability
	float dt = 0.25; // timestep (seconds)
	float stabilize = 0.28; // stabilize via weak neighbor averaging
	float grayify = 0.001; // very slight draw toward grayscale (avoid saturation)

	vec4 new_C = C + d_dt*dt; // take the timestep
	vec4 average = (L+R+T+B)*0.25;
	vec4 stabilized_C = mix(new_C,average,stabilize);
	COLOR = mix(stabilized_C, vec4(0.5), grayify);

	float roundoff = 1.0/255.0; // correct this much pixel roundoff
	vec4 rando = texture(rando_texture,UV + fract(vec2(TIME*2.34,TIME*5.67)));
	COLOR += roundoff * (rando-0.5);

	// Boundary conditions
	if (TIME<1.0)
		COLOR = vec4(vec3(0.5),1.0); // reinitialize to solid gray

	// Add a bottom 'wave generator'
	if (UV.y>0.98) {
		float t = 8.0*TIME; // main wave cycle
		COLOR = 0.5+vec4(0.2*cos(2.0*TIME),0.4*sin(t),0.4*sin(t),1.0);
	}

	// Add a solid color ball in the middle
	if (length(UV-vec2(0.5,0.5))<0.1*abs(sin(TIME)))
		COLOR = vec4(0.7,0.7,0.7,1);
}
