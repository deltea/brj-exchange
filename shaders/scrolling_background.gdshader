shader_type canvas_item;

uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform vec4 color_3: source_color;
uniform vec4 color_4: source_color;
uniform sampler2D noise_texture: repeat_enable;
uniform float speed = 0.001;

void fragment() {
	vec2 uv_1 = UV + (vec2(speed, 0) * TIME);
	vec2 uv_2 = UV + (vec2(-speed, 0) * TIME);
	float noise_val_1 = texture(noise_texture, uv_1).r;
	float noise_val_2 = texture(noise_texture, uv_2).r;
	float noise_val = noise_val_1 + noise_val_2;

	vec4 color;
	if (noise_val > 1.5) color = color_1;
	else if (noise_val > 1.0) color = color_2;
	else if (noise_val > 0.5) color = color_3;
	else if (noise_val > 0.0) color = color_4;

	COLOR = color;
}
