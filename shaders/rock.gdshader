shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable;
uniform sampler2D noise_texture_2: repeat_enable;

void fragment() {
	vec4 overlapping_noise = texture(noise_texture_2, UV);
	float noise_value = texture(noise_texture, UV).r;
	COLOR = vec4(vec3(255.0), (noise_value > 0.5 ? 1.0 : 0.0) * overlapping_noise.r);
}
