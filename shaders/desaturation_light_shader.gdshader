shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec3 color : source_color = vec3(0.6, 1.0, 0.8);
uniform int albedo_type : hint_enum("Color", "Texture") = 0;

void fragment() {
	vec3 albedo = texture(albedo_texture, UV).rgb;
	vec3 albedo_color = mix(color, albedo, float(albedo_type));
	ALBEDO = albedo_color;
}

void light() {
	float bw = (min(ALBEDO.r, min(ALBEDO.g, ALBEDO.b)) + max(ALBEDO.r, max(ALBEDO.g, ALBEDO.b))) * 0.5f;
	vec3 desaturated = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION / (PI * ALBEDO);
	vec3 normal = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
	float remapped_dot = clamp(smoothstep(0.5, 0.2, dot(NORMAL, LIGHT)), 0.0, 1.0) * clamp(pow(ATTENUATION, 1.0/3.0), 0, 1);
	vec3 combined = mix(desaturated, normal, remapped_dot); 
	DIFFUSE_LIGHT += combined;
}
