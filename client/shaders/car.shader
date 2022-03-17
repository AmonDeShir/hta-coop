shader_type spatial;

uniform sampler2D texturemap : hint_albedo;


void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	
	float linear_depth = -view.z;
		
	ALBEDO = texture(texturemap, UV).rgb;
	ALPHA = 1.0		;
}