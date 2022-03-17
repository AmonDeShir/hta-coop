shader_type canvas_item;

vec4 get_color_from_camera(sampler2D screen_texture, vec2 screen_uv) {
	return texture(screen_texture, screen_uv);
}

vec3 sobiel_filter(sampler2D screen_texture, vec2 screen_uv, vec2 pixel_size) {
	vec3 sobiel = -8.4 * get_color_from_camera(screen_texture, screen_uv).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(0.0, pixel_size.y)).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(0.0, -pixel_size.y)).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(pixel_size.x, 0.0)).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(-pixel_size.x, 0.0)).xyz;
    sobiel += texture(screen_texture, screen_uv + pixel_size.xy).xyz;
    sobiel += texture(screen_texture, screen_uv - pixel_size.xy).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(-pixel_size.x, pixel_size.y)).xyz;
    sobiel += texture(screen_texture, screen_uv + vec2(pixel_size.x, -pixel_size.y)).xyz;
	
	return sobiel;
}


void fragment() {
	float minColor = 0.8;
	vec4 original = get_color_from_camera(TEXTURE, SCREEN_UV);
	vec3 filter = sobiel_filter(TEXTURE, SCREEN_UV, TEXTURE_PIXEL_SIZE);
	
    COLOR.xyz = vec3(0.8, 0.8, 0.8);
	COLOR.w = original.w / 0.25;
	
	if (abs(filter.x - original.x) < minColor || abs(filter.y - original.y) < minColor || abs(filter.z - original.z) < minColor) {
		COLOR.xyz = original.xyz ;
		COLOR.w = original.w;
	}
	
}