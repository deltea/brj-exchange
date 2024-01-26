shader_type canvas_item;

uniform float speed = 1;
uniform float strength = 100;
uniform vec2 direction = vec2(1, 0);
uniform sampler2D noise: repeat_enable;

void fragment() {
	vec2 uv = UV;
	vec2 movement = direction * speed * TIME;
	float noise_val = texture(noise, uv + movement).r - 0.5;
	uv += noise_val * SCREEN_PIXEL_SIZE * strength;
	COLOR = texture(TEXTURE, uv);
}