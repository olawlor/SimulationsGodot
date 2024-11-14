/*
 Draw terrain by shifting each PlaneMesh vertex vertically.
 Generates normals by sampling the heightmap's neighboring pixels.
*/
shader_type spatial;

uniform sampler2D heightmap : filter_linear, repeat_disable;
uniform float height_range = 10.0; // heightmap white (1.0) corresponds to this in meters
uniform float pixel_size = 2.0; // physical size of one heightmap pixel (sets slopes)

void vertex() {
	float height = texture(heightmap,UV).r;
	VERTEX.y += height * height_range;
}

void fragment() {

	// Sample neighboring heightmap pixels
	vec2 uvPixel = vec2(1.0)/vec2(textureSize(heightmap,0));
	vec4  T  = texture(heightmap,UV + vec2(0,-uvPixel.y));
	vec4 L   = texture(heightmap,UV + vec2(-uvPixel.x,0));
	vec4   R = texture(heightmap,UV + vec2(+uvPixel.x,0));
	vec4  B  = texture(heightmap,UV + vec2(0,+uvPixel.y));

	// Find normal tilts
	float tilt_x = height_range*(L.r - R.r)/pixel_size;
	float tilt_y = height_range*(B.r - T.r)/pixel_size;

	NORMAL_MAP = vec3(0.5+tilt_x,0.5+tilt_y,1.0);

	ALBEDO = vec3(0.5);

}
