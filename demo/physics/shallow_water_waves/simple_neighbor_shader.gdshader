/*
 Render Shallow Water Wave Equation onscreen
*/
shader_type canvas_item;

uniform float speed=0.2; // 'timestep' 
uniform sampler2D last_frame;

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
	COLOR = B-0.003;
	
	// Add a solid color ball
	if (length(UV-vec2(0.5,0.5))<0.1*abs(sin(TIME)))
		COLOR = vec4(2.0*UV.x,1.8*UV.y,1,1);
}
