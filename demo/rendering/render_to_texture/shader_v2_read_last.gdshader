shader_type canvas_item;

uniform float speed=1.0;
uniform sampler2D last_frame;

void vertex() {
	// Called for every vertex the material is visible on.
}

// Scale and rotate UV coords: pivot is the center of rot/scale.  Rotation is degrees.
//  adapted from: https://forum.godotengine.org/t/simple-texture-rotation-shader/24198/2
vec2 rotateUV(vec2 uv, vec2 pivot, float scale, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = scale*(uv.x * cosine - uv.y * sine);
    uv.y = scale*(uv.x * sine + uv.y * cosine);
    uv += pivot;

    return uv;
}

void fragment() {

	if (length(UV-vec2(0.5,0.5))<0.1*abs(sin(TIME)))
	{
		// center solid color
		COLOR = vec4(2.0*UV.x,1.8*UV.y,1,1);
	}
	else
	{
		// feedback area
		vec2 UVrot = rotateUV(UV, vec2(0.5,0.5), 0.995, 0.001);
		vec4 last_pixel = texture(last_frame,UVrot);

		COLOR = fract(last_pixel-0.003);
	}
}
