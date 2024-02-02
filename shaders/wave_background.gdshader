shader_type canvas_item;

uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform sampler2D noise_texture: repeat_enable;
uniform float scroll_speed = 1.0;
uniform vec2 scroll_direction = vec2(1, 0);
uniform float looseness = 0.9;

void fragment() {
	vec2 uv_1 = UV + (scroll_speed * scroll_direction * TIME);
	vec2 uv_2 = UV + (scroll_speed * -scroll_direction * TIME);
	float noise_val_1 = texture(noise_texture, uv_1).r;
	float noise_val_2 = texture(noise_texture, uv_2).r;
	COLOR = noise_val_1 + noise_val_2 < looseness ? color_1 : color_2;
}
