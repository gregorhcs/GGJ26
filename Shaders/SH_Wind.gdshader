shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform sampler2D noise_tex : repeat_enable;
uniform float noise_scale = 1.5;
uniform float fog_speed = 0.02;
uniform float fog_density : hint_range(0.0, 1.0) = 0.35;
uniform vec4 fog_color : source_color = vec4(0.8, 0.8, 0.85, 1.0);

void fragment() {
	vec2 uv = SCREEN_UV;

	// animated noise
	vec2 flow = vec2(0.1, 0.05) * TIME * fog_speed;
	float n = texture(noise_tex, uv * noise_scale + flow).r;

	// soften
	n = smoothstep(0.3, 0.7, n);

	// final alpha
	float alpha = n * fog_density;

	COLOR = vec4(fog_color.rgb, alpha);
}
