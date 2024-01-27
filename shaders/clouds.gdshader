shader_type canvas_item;

uniform vec3 color: source_color;
uniform float scroll_speed = 0.05;
uniform float merge_speed = 0.02;
uniform sampler2D noise: repeat_enable;
uniform float looseness = 0.2;

void fragment() {
	vec4 noise_val_1 = texture(noise, vec2(UV.x + TIME * merge_speed + TIME * scroll_speed, UV.y));
	vec4 noise_val_2 = texture(noise, vec2(UV.x - TIME * merge_speed + TIME * scroll_speed, UV.y));
	float a = noise_val_1.r * noise_val_2.r > looseness ? 1.0 : 0.0;
	COLOR = vec4(color.rgb, a);
}
