shader_type canvas_item;

uniform float speed = 0.1;
uniform float strength = 0.02;
uniform vec2 direction = vec2(1, 0);
uniform sampler2D screen: hint_screen_texture;
uniform sampler2D noise: repeat_enable;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 movement = direction * speed * TIME;
	float noise_val = texture(noise, uv + movement).r - 0.5;
	COLOR = texture(screen, vec2(uv.x + noise_val * strength, uv.y));
}