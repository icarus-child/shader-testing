shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float red_offset = 0.4;
uniform float green_offset = 0;
uniform float blue_offset = -0.2;
uniform int pixel_scale = 100;
const float balance = 0.001;

uniform float shake_speed = 2.0;
uniform float shake_rate = 0.2;
uniform float block_size_x = 15.0;
uniform float block_size_y = 15.0;

float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	bool enable_shift_y = bool(
		random(
			( floor( UV.y * block_size_y ) / block_size_y ) * round(mod(TIME, 100.0) * 3.0)
		) - 0.5 > shake_rate
	);
	bool enable_shift_x = bool(
		random(
			( 1.0 + floor( UV.x * block_size_x ) / block_size_x ) * round(mod(TIME, 100.0) * 3.0)
		) - 0.5 > shake_rate
	);
	bool enable_shift = enable_shift_x || enable_shift_y;
	
	vec2 grid_uv = round(SCREEN_UV * VIEWPORT_SIZE * float(pixel_scale) * balance) / (float(pixel_scale) * VIEWPORT_SIZE * balance);
	vec2 uv = mix(grid_uv, SCREEN_UV, float(enable_shift));
	float distance_to_camera = FRAGCOORD.z;
	vec3 base = textureLod(screen_texture, SCREEN_UV, 0).rgb;
	vec3 c;
	c.r = textureLod(screen_texture, uv + vec2(red_offset * distance_to_camera, 0), 0.0).r;
	c.g = textureLod(screen_texture, uv + vec2(green_offset * distance_to_camera, 0), 0.0).g;
	c.b = textureLod(screen_texture, uv + vec2(blue_offset * distance_to_camera, 0), 0.0).b;
	
	c = c * vec3(1, 1, 0);

	ALBEDO.rgb = mix(c, base, float(enable_shift));
}