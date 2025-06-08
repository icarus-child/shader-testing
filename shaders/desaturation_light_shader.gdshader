shader_type spatial;

uniform vec3 color : source_color = vec3(0.8,0.6,0.6); 

void fragment() {
	ALBEDO = color;
}

void light() {
	float bw = (min(ALBEDO.r, min(ALBEDO.g, ALBEDO.b)) + max(ALBEDO.r, max(ALBEDO.g, ALBEDO.b))) * 0.5f;
	vec3 desaturated = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION / (PI * ALBEDO);
	//vec3 normal = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
	DIFFUSE_LIGHT += desaturated;
}
