/*
 Implements reaction-diffusion style plant growth on a terrain.
*/
shader_type canvas_item;

uniform float speed=1.0;
uniform sampler2D last_frame : filter_linear;
uniform sampler2D rando_texture : repeat_enable;

void vertex() {
}

void fragment() {
	// Load our color
	vec4 C = texture(last_frame,UV);

	// Load our neighboring pixels (plus some jitter to break up the pixel grid)
	vec2 uvPixel = 1.0 / vec2(textureSize(last_frame,0));
	vec4 rando = texture(rando_texture,UV + fract(vec2(23.4*TIME,56.7*TIME)));
	vec2 UVc = UV + uvPixel * 0.5*(rando.rg - 0.5); // jittered samples
	vec4  T  = texture(last_frame,UVc + vec2(0,-uvPixel.y));
	vec4 L   = texture(last_frame,UVc + vec2(-uvPixel.x,0));
	vec4   R = texture(last_frame,UVc + vec2(+uvPixel.x,0));
	vec4  B  = texture(last_frame,UVc + vec2(0,+uvPixel.y));

	/*
	 Turk-Turing Reaction Diffusion Equations
	*/
	float Rs = 0.20; // reaction rate
	float beta = UV.y; // vary the decay rate

	// Compute the reaction rates
	float reaction = 8.0 * C.g * C.b;
	float Db = Rs*(1.0 - reaction);
	float Dg = Rs*(reaction - C.g - beta);

	// Take a timestep with those rates
	C += vec4(0.0, Dg, Db, 0.0);

	// Apply diffusion
	float Ng = 0.25; // diffusion rate for green
	float Nb = 0.95; // diffusion rate for blue water
	vec4 avg = (T+L+R+B)*0.25;
	C.g += Ng * (avg.g - C.g);
	C.b += Nb * (avg.b - C.b);

	// Don't let C go negative (it blows up)
	C = clamp(C,vec4(0.01),vec4(1.0));

	// Modify a bouncing area
	if (length(UV-vec2(0.5,0.5+0.5*sin(TIME)))<0.05) {
		C = vec4(0,1.0,0.5,1);
	}
	C.r = 0.0; // don't redden

	COLOR = C; // write our updated color
	COLOR.a = 1.0; // (don't go transparent)
}
