shader_type canvas_item;

uniform float scroll_speed = 0.05;
uniform float merge_speed = 0.01;
uniform sampler2D noise: repeat_enable;

void fragment() {
	vec4 noise_val_1 = texture(noise, vec2(UV.x + TIME * merge_speed + TIME * scroll_speed, UV.y));
	vec4 noise_val_2 = texture(noise, vec2(UV.x - TIME * merge_speed + TIME * scroll_speed, UV.y));
	float a = noise_val_1.r * noise_val_2.r > 0.2 ? 1.0 : 0.0;
	COLOR = vec4(255, 255, 255, a);
}
