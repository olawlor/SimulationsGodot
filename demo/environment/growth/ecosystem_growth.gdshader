/*
 Implements ecosystem plant growth on a terrain.

*/
shader_type canvas_item;

uniform float speed=1.0;
uniform sampler2D last_frame : filter_linear, repeat_enable;
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

	vec4 neighbors = (T + L + R + B)*0.25;

	/*
	 Parameters:
		red: topsoil thickness (0: none, 1:deep soil)
		green: vegetation growth (0: bare rocks, 1: lush forest)
		blue: soil moisture (0: bone dry, 1: wet)
	*/
	float moisture = C.b;
	float veg = C.g;
	float sunlight = 1.0 - neighbors.g; // <- vegetation shades everything nearby
	float topsoil = C.r;

	float rate_growth = 0.15; // maximum amount vegetation can grow per year
	float rate_decay = 0.05; // proportion of vegetation that decays
	float rate_soil_base = 0.1; // basic growth rate with no soil
	float rate_soil_loss = 0.01; // percent soil thickness lost per year
	float rate_newsoil = 1.0; // rate at which vegetation builds soil
	float rate_rainfall = 0.05+0.03*sin(3.141592*(UV.y*4.0+0.02*TIME)); // raw incoming rainfall (meters per year)
	float rate_transpiration = 0.1; // moisture loss due to vegetation
	float rate_evaporation = 0.05; // unshaded evaporation

	float change_veg = rate_growth * moisture * sunlight * neighbors.g * (rate_soil_base+topsoil);
	change_veg -= rate_decay * veg;
	float change_soil = -rate_soil_loss * topsoil;
	// build soil if enough vegetation nearby
	if (neighbors.g > 0.1) change_soil += rate_newsoil * neighbors.g;

	float change_moisture = rate_rainfall - rate_transpiration * veg - rate_evaporation * sunlight;

	float dt = 1.0; // timestep size
	C += dt * vec4(change_soil, change_veg, change_moisture,0.0);

	// Moisture transports in all directions (diffusion)
	float rate_moisture_transport = 0.3;
	C.b += rate_moisture_transport*(neighbors.b - C.b);

	// Persistent lush seed area
	if (length(UV-vec2(0.2,0.5))<0.05) {
		C = vec4(1.0,1.0,0.4,1);
	}

	// Prevent solution going negative (tends to exponential downhill)
	C = clamp(C, vec4(0.0), vec4(1.0));

	COLOR = C; // write our updated color
	COLOR.a = 1.0; // (don't go transparent)
}
